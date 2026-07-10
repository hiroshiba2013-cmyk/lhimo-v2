import { useState, useEffect } from 'react';
import { Mail, Phone, MapPin, Clock, Send, CheckCircle, AlertCircle, Facebook, Instagram, Twitter, MessageCircle } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

const SUBJECTS = [
  'Informazioni generali',
  'Problemi tecnici',
  'Segnalazione contenuto',
  'Richiesta rimborso',
  'Collaborazione / Partnership',
  'Altro',
];

interface ContactInfo {
  email: string;
  phone: string;
  address: { street: string; city: string; cap: string; country: string };
  facebook: string;
  instagram: string;
  twitter: string;
  whatsapp: string;
  supportHours: string;
}

const DEFAULTS: ContactInfo = {
  email: 'info@lhimo.it',
  phone: '',
  address: { street: 'Via Roma, 123', city: 'Milano', cap: '20100', country: 'Italia' },
  facebook: '',
  instagram: '',
  twitter: '',
  whatsapp: '',
  supportHours: 'Lun - Ven: 9:00 - 18:00',
};

export function ContactPage() {
  const { user, profile } = useAuth();

  const [contactInfo, setContactInfo] = useState<ContactInfo>(DEFAULTS);
  const [form, setForm] = useState({
    name: profile?.full_name || '',
    email: user?.email || '',
    subject: '',
    message: '',
  });
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    supabase
      .from('platform_settings')
      .select('setting_key, setting_value')
      .eq('category', 'contact')
      .then(({ data }) => {
        if (!data?.length) return;
        const info: ContactInfo = { ...DEFAULTS };
        data.forEach(row => {
          switch (row.setting_key) {
            case 'contact_email': info.email = row.setting_value?.value || DEFAULTS.email; break;
            case 'contact_phone': info.phone = row.setting_value?.value || ''; break;
            case 'contact_address': info.address = { ...DEFAULTS.address, ...row.setting_value }; break;
            case 'contact_social_facebook': info.facebook = row.setting_value?.value || ''; break;
            case 'contact_social_instagram': info.instagram = row.setting_value?.value || ''; break;
            case 'contact_social_twitter': info.twitter = row.setting_value?.value || ''; break;
            case 'contact_whatsapp': info.whatsapp = row.setting_value?.value || ''; break;
            case 'contact_support_hours': info.supportHours = row.setting_value?.value || DEFAULTS.supportHours; break;
          }
        });
        setContactInfo(info);
      });
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.name || !form.email || !form.subject || !form.message) return;

    setSending(true);
    setError('');

    const { error: err } = await supabase.from('platform_messages').insert({
      name: form.name,
      email: form.email,
      subject: form.subject,
      message: form.message,
      user_id: user?.id ?? null,
    });

    setSending(false);

    if (err) {
      setError("Errore durante l'invio. Riprova tra qualche momento.");
      return;
    }

    setSent(true);
    setForm(prev => ({ ...prev, subject: '', message: '' }));
  };

  const hasSocials = contactInfo.facebook || contactInfo.instagram || contactInfo.twitter || contactInfo.whatsapp;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero */}
      <section className="bg-white border-b border-gray-100">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20 text-center">
          <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
            <div className="w-1.5 h-1.5 bg-blue-500 rounded-full" />
            Siamo qui per aiutarti
          </div>
          <h1 className="text-4xl md:text-5xl font-extrabold text-gray-900 leading-tight mb-4">
            Contattaci
          </h1>
          <p className="text-lg text-gray-500 max-w-2xl mx-auto">
            Hai domande, segnalazioni o hai bisogno di assistenza? Scrivici e ti risponderemo al piu' presto.
          </p>
        </div>
      </section>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid md:grid-cols-2 gap-8 mb-12">

          {/* Info di contatto */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-8">
            <h2 className="text-xl font-bold text-gray-900 mb-6">Informazioni di Contatto</h2>
            <div className="space-y-6">
              {contactInfo.email && (
                <div className="flex items-start gap-4">
                  <div className="w-11 h-11 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <Mail className="w-5 h-5 text-blue-600" />
                  </div>
                  <div>
                    <p className="font-semibold text-gray-900 text-sm mb-0.5">Email</p>
                    {contactInfo.email.split(',').map(e => (
                      <p key={e} className="text-gray-600 text-sm">{e.trim()}</p>
                    ))}
                  </div>
                </div>
              )}

              {contactInfo.phone && (
                <div className="flex items-start gap-4">
                  <div className="w-11 h-11 bg-green-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <Phone className="w-5 h-5 text-green-600" />
                  </div>
                  <div>
                    <p className="font-semibold text-gray-900 text-sm mb-0.5">Telefono</p>
                    <p className="text-gray-600 text-sm">{contactInfo.phone}</p>
                    {contactInfo.supportHours && (
                      <p className="text-gray-500 text-xs">{contactInfo.supportHours}</p>
                    )}
                  </div>
                </div>
              )}

              {(contactInfo.address.street || contactInfo.address.city) && (
                <div className="flex items-start gap-4">
                  <div className="w-11 h-11 bg-amber-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <MapPin className="w-5 h-5 text-amber-600" />
                  </div>
                  <div>
                    <p className="font-semibold text-gray-900 text-sm mb-0.5">Sede</p>
                    {contactInfo.address.street && <p className="text-gray-600 text-sm">{contactInfo.address.street}</p>}
                    {contactInfo.address.city && (
                      <p className="text-gray-600 text-sm">
                        {[contactInfo.address.cap, contactInfo.address.city, contactInfo.address.country].filter(Boolean).join(', ')}
                      </p>
                    )}
                  </div>
                </div>
              )}

              {contactInfo.supportHours && !contactInfo.phone && (
                <div className="flex items-start gap-4">
                  <div className="w-11 h-11 bg-gray-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <Clock className="w-5 h-5 text-gray-500" />
                  </div>
                  <div>
                    <p className="font-semibold text-gray-900 text-sm mb-0.5">Orari</p>
                    {contactInfo.supportHours.split(',').map(h => (
                      <p key={h} className="text-gray-600 text-sm">{h.trim()}</p>
                    ))}
                  </div>
                </div>
              )}

              {hasSocials && (
                <div className="pt-2 border-t border-gray-100">
                  <p className="font-semibold text-gray-900 text-sm mb-3">Social</p>
                  <div className="flex gap-3">
                    {contactInfo.facebook && (
                      <a href={contactInfo.facebook} target="_blank" rel="noopener noreferrer"
                        className="w-9 h-9 bg-blue-100 text-blue-700 rounded-lg flex items-center justify-center hover:bg-blue-200 transition-colors">
                        <Facebook className="w-4 h-4" />
                      </a>
                    )}
                    {contactInfo.instagram && (
                      <a href={contactInfo.instagram} target="_blank" rel="noopener noreferrer"
                        className="w-9 h-9 bg-pink-100 text-pink-700 rounded-lg flex items-center justify-center hover:bg-pink-200 transition-colors">
                        <Instagram className="w-4 h-4" />
                      </a>
                    )}
                    {contactInfo.twitter && (
                      <a href={contactInfo.twitter} target="_blank" rel="noopener noreferrer"
                        className="w-9 h-9 bg-sky-100 text-sky-700 rounded-lg flex items-center justify-center hover:bg-sky-200 transition-colors">
                        <Twitter className="w-4 h-4" />
                      </a>
                    )}
                    {contactInfo.whatsapp && (
                      <a href={`https://wa.me/${contactInfo.whatsapp.replace(/\D/g, '')}`} target="_blank" rel="noopener noreferrer"
                        className="w-9 h-9 bg-green-100 text-green-700 rounded-lg flex items-center justify-center hover:bg-green-200 transition-colors">
                        <MessageCircle className="w-4 h-4" />
                      </a>
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Form */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-8">
            <h2 className="text-xl font-bold text-gray-900 mb-6">Inviaci un Messaggio</h2>

            {sent ? (
              <div className="flex flex-col items-center justify-center py-10 text-center gap-4">
                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center">
                  <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
                <div>
                  <p className="text-lg font-semibold text-gray-900 mb-1">Messaggio inviato!</p>
                  <p className="text-sm text-gray-500">Ti risponderemo all'indirizzo email indicato il prima possibile.</p>
                </div>
                <button
                  onClick={() => setSent(false)}
                  className="mt-2 text-sm text-blue-600 hover:text-blue-700 font-medium"
                >
                  Invia un altro messaggio
                </button>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">
                      Nome Completo <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      required
                      value={form.name}
                      onChange={e => setForm(prev => ({ ...prev, name: e.target.value }))}
                      placeholder="Mario Rossi"
                      className="w-full px-3 py-2.5 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">
                      Email <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="email"
                      required
                      value={form.email}
                      onChange={e => setForm(prev => ({ ...prev, email: e.target.value }))}
                      placeholder="mario@email.com"
                      className="w-full px-3 py-2.5 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">
                    Oggetto <span className="text-red-500">*</span>
                  </label>
                  <select
                    required
                    value={form.subject}
                    onChange={e => setForm(prev => ({ ...prev, subject: e.target.value }))}
                    className="w-full px-3 py-2.5 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none bg-white"
                  >
                    <option value="">Seleziona oggetto...</option>
                    {SUBJECTS.map(s => <option key={s} value={s}>{s}</option>)}
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">
                    Messaggio <span className="text-red-500">*</span>
                  </label>
                  <textarea
                    required
                    rows={5}
                    value={form.message}
                    onChange={e => setForm(prev => ({ ...prev, message: e.target.value }))}
                    placeholder="Descrivi il tuo problema o la tua richiesta..."
                    className="w-full px-3 py-2.5 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none resize-none"
                  />
                </div>

                {error && (
                  <div className="flex items-center gap-2 text-sm text-red-600 bg-red-50 border border-red-200 rounded-lg px-3 py-2.5">
                    <AlertCircle className="w-4 h-4 flex-shrink-0" />
                    {error}
                  </div>
                )}

                <button
                  type="submit"
                  disabled={sending}
                  className="w-full flex items-center justify-center gap-2 bg-blue-600 text-white py-2.5 px-6 rounded-lg hover:bg-blue-700 transition-colors font-semibold text-sm disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  {sending ? (
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  ) : (
                    <Send className="w-4 h-4" />
                  )}
                  {sending ? 'Invio in corso...' : 'Invia Messaggio'}
                </button>
              </form>
            )}
          </div>
        </div>

        <div className="bg-gradient-to-r from-blue-50 to-sky-50 border border-blue-200 rounded-xl p-8 text-center">
          <h2 className="text-xl font-bold text-gray-900 mb-3">Domande Frequenti</h2>
          <p className="text-gray-600 mb-5 text-sm">
            Prima di contattarci, consulta le nostre FAQ per trovare risposte immediate.
          </p>
          <a href="/rules" className="inline-block bg-blue-600 text-white px-6 py-2.5 rounded-lg hover:bg-blue-700 transition-colors font-semibold text-sm">
            Vai alle FAQ
          </a>
        </div>
      </div>
    </div>
  );
}
