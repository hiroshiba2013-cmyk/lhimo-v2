# Guida Implementazione Trial Prevention - Frontend

## Modifiche Necessarie

### 1. Form di Registrazione

Aggiungere campo **obbligatorio** per codice fiscale e validazione real-time.

```typescript
// src/components/auth/RegisterForm.tsx

import { useState } from 'react';
import { supabase } from '@/lib/supabase';

export function RegisterForm() {
  const [fiscalCode, setFiscalCode] = useState('');
  const [fiscalCodeError, setFiscalCodeError] = useState('');
  const [isCheckingFiscalCode, setIsCheckingFiscalCode] = useState(false);

  // Valida CF in tempo reale
  const validateFiscalCode = async (cf: string) => {
    if (!cf || cf.length < 16) {
      setFiscalCodeError('Il codice fiscale deve essere di 16 caratteri');
      return false;
    }

    setIsCheckingFiscalCode(true);

    try {
      const { data, error } = await supabase.rpc('check_fiscal_code_trial_eligibility', {
        p_fiscal_code: cf.toUpperCase()
      });

      if (error) {
        setFiscalCodeError('Errore nella verifica del codice fiscale');
        return false;
      }

      if (!data.eligible) {
        setFiscalCodeError(data.message);
        return false;
      }

      setFiscalCodeError('');
      return true;
    } catch (err) {
      setFiscalCodeError('Errore di connessione');
      return false;
    } finally {
      setIsCheckingFiscalCode(false);
    }
  };

  const handleFiscalCodeBlur = async () => {
    await validateFiscalCode(fiscalCode);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Valida CF prima di procedere
    const isFiscalCodeValid = await validateFiscalCode(fiscalCode);
    if (!isFiscalCodeValid) {
      alert('Il codice fiscale non è valido o ha già usufruito del periodo di prova');
      return;
    }

    // Procedi con la registrazione
    // ... resto del codice
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Altri campi... */}

      <div>
        <label>
          Codice Fiscale *
          <span className="text-xs text-gray-500">
            (Obbligatorio per attivare il periodo di prova)
          </span>
        </label>
        <input
          type="text"
          value={fiscalCode}
          onChange={(e) => setFiscalCode(e.target.value.toUpperCase())}
          onBlur={handleFiscalCodeBlur}
          maxLength={16}
          required
          className={fiscalCodeError ? 'border-red-500' : ''}
        />

        {isCheckingFiscalCode && (
          <p className="text-sm text-blue-600">
            Verifica in corso...
          </p>
        )}

        {fiscalCodeError && (
          <p className="text-sm text-red-600">
            {fiscalCodeError}
          </p>
        )}

        {!fiscalCodeError && fiscalCode.length === 16 && !isCheckingFiscalCode && (
          <p className="text-sm text-green-600">
            ✓ Codice fiscale valido
          </p>
        )}
      </div>

      <button type="submit" disabled={isCheckingFiscalCode || !!fiscalCodeError}>
        Registrati
      </button>
    </form>
  );
}
```

### 2. Aggiunta Membri Famiglia

Gestire errori quando si aggiunge un membro con CF già usato.

```typescript
// src/components/profile/EditFamilyMembersForm.tsx

async function addFamilyMember(memberData: FamilyMemberData) {
  try {
    const { data, error } = await supabase
      .from('customer_family_members')
      .insert({
        customer_id: user.id,
        first_name: memberData.firstName,
        last_name: memberData.lastName,
        date_of_birth: memberData.dateOfBirth,
        tax_code: memberData.taxCode,
        relationship: memberData.relationship
      })
      .select()
      .single();

    if (error) {
      // Errore 23514 = trial già usato
      if (error.code === '23514') {
        alert(
          'Questo membro della famiglia ha un codice fiscale che ha già usufruito ' +
          'del periodo di prova. Non è possibile aggiungerlo all\'account.'
        );
        return;
      }

      throw error;
    }

    alert('Membro della famiglia aggiunto con successo!');
    // Ricarica lista famiglia
  } catch (err) {
    console.error('Errore aggiunta membro:', err);
    alert('Si è verificato un errore durante l\'aggiunta del membro');
  }
}
```

### 3. Dashboard Admin - Statistiche Trial

Aggiungere sezione per monitorare abusi trial.

```typescript
// src/components/admin/TrialStatisticsSection.tsx

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';

interface TrialStats {
  total_registered_fiscal_codes: number;
  total_attempts_blocked: number;
  active_trials: number;
  recent_blocked_attempts: Array<{
    fiscal_code: string;
    attempts: number;
    last_attempt: string;
  }>;
}

export function TrialStatisticsSection() {
  const [stats, setStats] = useState<TrialStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadStats();
  }, []);

  async function loadStats() {
    try {
      const { data, error } = await supabase.rpc('get_trial_statistics');

      if (error) throw error;

      setStats(data);
    } catch (err) {
      console.error('Errore caricamento statistiche:', err);
    } finally {
      setLoading(false);
    }
  }

  if (loading) return <div>Caricamento...</div>;
  if (!stats) return <div>Errore nel caricamento delle statistiche</div>;

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Statistiche Trial</h2>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-blue-50 p-6 rounded-lg">
          <h3 className="text-sm text-gray-600">Codici Fiscali Registrati</h3>
          <p className="text-3xl font-bold text-blue-600">
            {stats.total_registered_fiscal_codes}
          </p>
        </div>

        <div className="bg-red-50 p-6 rounded-lg">
          <h3 className="text-sm text-gray-600">Tentativi Bloccati</h3>
          <p className="text-3xl font-bold text-red-600">
            {stats.total_attempts_blocked}
          </p>
        </div>

        <div className="bg-green-50 p-6 rounded-lg">
          <h3 className="text-sm text-gray-600">Trial Attivi</h3>
          <p className="text-3xl font-bold text-green-600">
            {stats.active_trials}
          </p>
        </div>
      </div>

      <div>
        <h3 className="text-lg font-semibold mb-4">Ultimi Tentativi Bloccati</h3>

        {stats.recent_blocked_attempts.length === 0 ? (
          <p className="text-gray-500">Nessun tentativo bloccato recente</p>
        ) : (
          <div className="bg-white rounded-lg shadow overflow-hidden">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                    Codice Fiscale
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                    Tentativi
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                    Ultimo Tentativo
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {stats.recent_blocked_attempts.map((attempt, index) => (
                  <tr key={index}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-mono">
                      {attempt.fiscal_code}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                        {attempt.attempts}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {new Date(attempt.last_attempt).toLocaleString('it-IT')}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <button
        onClick={loadStats}
        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      >
        Aggiorna Statistiche
      </button>
    </div>
  );
}
```

### 4. Controllo Utente Specifico (Admin)

```typescript
// src/components/admin/UserTrialDetails.tsx

async function checkUserTrialEligibility(userId: string) {
  try {
    const { data, error } = await supabase.rpc('get_user_trial_details', {
      p_user_id: userId
    });

    if (error) throw error;

    return {
      isEligible: data.is_eligible,
      userFiscalCode: data.user_fiscal_code,
      familyFiscalCodes: data.family_fiscal_codes,
      blockedFiscalCodes: data.blocked_fiscal_codes,
      eligibilityCheck: data.eligibility_check
    };
  } catch (err) {
    console.error('Errore controllo idoneità:', err);
    return null;
  }
}

// Uso:
const details = await checkUserTrialEligibility(selectedUserId);

if (details && !details.isEligible) {
  console.log('Utente NON idoneo al trial');
  console.log('Motivo:', details.eligibilityCheck.message);
  console.log('CF bloccati:', details.blockedFiscalCodes);
}
```

## Messaggi da Mostrare all'Utente

### Durante la Registrazione

```
❌ "Il codice fiscale è obbligatorio per attivare il periodo di prova"
❌ "Questo codice fiscale ha già usufruito del periodo di prova"
✅ "Codice fiscale valido - puoi procedere con la registrazione"
```

### Durante Aggiunta Membri

```
❌ "Questo membro della famiglia ha un codice fiscale che ha già usufruito del periodo di prova"
❌ "Un membro della famiglia ha già attivato un trial. Non è possibile usufruire nuovamente del periodo di prova"
```

### Per gli Admin

```
ℹ️ "Codici fiscali registrati: 1,234"
⚠️ "Tentativi di abuso bloccati: 56"
✅ "Trial attivi: 89"
```

## Test Frontend

### Test Manuale

1. **Registrazione con CF nuovo**
   - Inserire CF valido mai usato
   - Verificare che il trial si attivi

2. **Registrazione con CF già usato**
   - Inserire CF già usato in precedenza
   - Verificare messaggio errore

3. **Aggiunta membro con CF bloccato**
   - Provare ad aggiungere membro con CF già usato
   - Verificare errore

4. **Dashboard admin**
   - Verificare statistiche
   - Controllare lista tentativi bloccati

## Checklist Implementazione

- [ ] Campo codice fiscale obbligatorio in registrazione
- [ ] Validazione real-time CF durante registrazione
- [ ] Gestione errore 23514 in aggiunta membri famiglia
- [ ] Sezione statistiche trial in dashboard admin
- [ ] Messaggi utente chiari e informativi
- [ ] Test tutti gli scenari
- [ ] Documentazione per team

## Note Importanti

1. Il CF deve essere in **maiuscolo** (il sistema lo converte automaticamente)
2. La validazione è **case-insensitive** nel database
3. Gli errori sono **user-friendly** (niente codici tecnici agli utenti)
4. Le statistiche admin **oscurano parzialmente** i CF per privacy
5. Il sistema è **retroattivo** (utenti esistenti già registrati)

## Supporto Utenti

### FAQ da Aggiungere

**Q: Perché mi chiede il codice fiscale?**
A: Il codice fiscale è necessario per attivare il periodo di prova gratuito di 30 giorni e prevenire abusi del sistema.

**Q: È sicuro inserire il mio codice fiscale?**
A: Sì, il tuo codice fiscale è protetto e utilizzato solo per identificare univocamente il tuo account, in conformità con il GDPR.

**Q: Ho già usato il trial in passato, posso usarlo di nuovo?**
A: No, il periodo di prova è utilizzabile una sola volta per codice fiscale.

**Q: Un membro della mia famiglia ha già usato il trial, posso comunque usarlo?**
A: No, il trial è legato al nucleo familiare. Se anche un solo membro lo ha già utilizzato, non è possibile attivarlo nuovamente.
