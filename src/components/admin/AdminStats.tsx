import { Star, ShoppingBag, Briefcase, Search, Gift, Gavel, Users, CreditCard, Heart, Building2, AlertTriangle, Clock, TrendingUp, UserCheck, Activity, Calendar } from 'lucide-react';

const PERIOD_OPTIONS: { label: string; days: number | null }[] = [
  { label: 'Tutti', days: null },
  { label: 'Oggi', days: 1 },
  { label: '7 giorni', days: 7 },
  { label: '15 giorni', days: 15 },
  { label: '30 giorni', days: 30 },
  { label: '90 giorni', days: 90 },
  { label: '180 giorni', days: 180 },
];

interface AdminStatsProps {
  stats: {
    totalUsers: number;
    trialUsers: number;
    totalReviews: number;
    pendingReviews: number;
    totalAds: number;
    adsSell: number;
    adsBuy: number;
    adsGift: number;
    activeSubscriptions: number;
    trialSubscriptions: number;
    totalBusinesses: number;
    totalReports: number;
    pendingReports: number;
    pendingAds: number;
    pendingJobs: number;
    pendingAuctions: number;
    totalJobPostings: number;
    totalJobSeekers: number;
    totalAuctions: number;
    registeredBusinesses: number;
    importedBusinesses: number;
    userAddedBusinesses: number;
    claimedBusinesses: number;
    selfRegisteredBusinesses: number;
    totalLocations: number;
    totalFamilyMembers: number;
    solidarityTotal: number;
  };
  period: number | null;
  onPeriodChange: (days: number | null) => void;
}

interface StatCardProps {
  title: string;
  value: number | string;
  subtitle?: string;
  icon: React.ElementType;
  iconBg: string;
  iconColor: string;
  badge?: { label: string; value: number | string; color: string };
  breakdown?: { label: string; value: number | string }[];
}

function StatCard({ title, value, subtitle, icon: Icon, iconBg, iconColor, badge, breakdown }: StatCardProps) {
  return (
    <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow duration-200">
      <div className="flex items-start justify-between mb-3">
        <div className={`p-2.5 rounded-lg ${iconBg}`}>
          <Icon className={`w-5 h-5 ${iconColor}`} />
        </div>
        {badge && (
          <span className={`text-xs font-semibold px-2 py-1 rounded-full ${badge.color}`}>
            {badge.value} {badge.label}
          </span>
        )}
      </div>
      <div className="mt-1">
        <p className="text-2xl font-bold text-gray-900 leading-tight">
          {typeof value === 'number' ? value.toLocaleString('it-IT') : value}
        </p>
        <p className="text-sm font-medium text-gray-600 mt-0.5">{title}</p>
        {subtitle && <p className="text-xs text-gray-400 mt-0.5">{subtitle}</p>}
        {breakdown && breakdown.length > 0 && (
          <div className="mt-2.5 pt-2.5 border-t border-gray-100 flex flex-wrap gap-x-3 gap-y-1">
            {breakdown.map(b => (
              <span key={b.label} className="text-xs text-gray-500">
                <span className="font-semibold text-gray-700">{typeof b.value === 'number' ? b.value.toLocaleString('it-IT') : b.value}</span> {b.label}
              </span>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export function AdminStats({ stats, period, onPeriodChange }: AdminStatsProps) {
  const approvalRate = stats.totalReviews > 0
    ? Math.round(((stats.totalReviews - stats.pendingReviews) / stats.totalReviews) * 100)
    : 0;

  const solidarityFormatted = stats.solidarityTotal.toLocaleString('it-IT', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });

  const activePeriodLabel = PERIOD_OPTIONS.find(o => o.days === period)?.label ?? 'Tutti';

  return (
    <div className="space-y-8">

      {/* Header + filtro periodo */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">Panoramica Piattaforma</h2>
          {period !== null && (
            <p className="text-sm text-gray-500 mt-0.5">
              Dati di attivita' per gli ultimi {period === 1 ? 'giorno' : `${period} giorni`}
              {' '}— abbonamenti e moderazione sono sempre aggiornati al momento attuale
            </p>
          )}
        </div>
        <div className="flex items-center gap-3 flex-wrap">
          <div className="flex items-center gap-1.5 text-sm text-gray-500">
            <Calendar className="w-4 h-4" />
            <span className="font-medium">Periodo:</span>
          </div>
          <div className="flex flex-wrap gap-1.5">
            {PERIOD_OPTIONS.map(({ label, days }) => (
              <button
                key={label}
                onClick={() => onPeriodChange(days)}
                className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
                  period === days
                    ? 'bg-blue-600 text-white shadow-sm'
                    : 'bg-white text-gray-600 border border-gray-200 hover:border-blue-300 hover:text-blue-600'
                }`}
              >
                {label}
              </button>
            ))}
          </div>
          <div className="flex items-center gap-2 px-3 py-1.5 bg-green-50 border border-green-200 rounded-lg">
            <Activity className="w-4 h-4 text-green-600" />
            <span className="text-sm font-medium text-green-700">Sistema Attivo</span>
          </div>
        </div>
      </div>

      {/* Banner periodo attivo */}
      {period !== null && (
        <div className="flex items-center gap-2 px-4 py-2.5 bg-blue-50 border border-blue-200 rounded-lg text-sm text-blue-700">
          <Calendar className="w-4 h-4 flex-shrink-0" />
          <span>Stai visualizzando l'attivita' degli <strong>ultimi {period === 1 ? 'giorno' : `${period} giorni`}</strong> ({activePeriodLabel}). I contatori di abbonamenti attivi, utenti in prova e elementi in moderazione riflettono sempre lo stato attuale.</span>
        </div>
      )}

      {/* Sezione: Da Moderare */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <AlertTriangle className="w-4 h-4" /> Da Moderare
          <span className="text-xs font-normal text-gray-400 normal-case tracking-normal">(stato attuale)</span>
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
          {/* Recensioni da approvare */}
          <div className={`bg-white rounded-xl border shadow-sm p-5 flex flex-col gap-3 ${stats.pendingReviews > 0 ? 'border-orange-200' : 'border-gray-100'}`}>
            <div className={`p-2.5 rounded-lg w-fit ${stats.pendingReviews > 0 ? 'bg-orange-50' : 'bg-gray-50'}`}>
              <Star className={`w-5 h-5 ${stats.pendingReviews > 0 ? 'text-orange-500' : 'text-gray-400'}`} />
            </div>
            <div>
              <p className={`text-2xl font-bold ${stats.pendingReviews > 0 ? 'text-orange-600' : 'text-gray-900'}`}>
                {stats.pendingReviews.toLocaleString('it-IT')}
              </p>
              <p className="text-sm font-medium text-gray-600 mt-0.5">Recensioni</p>
              <p className="text-xs text-gray-400 mt-0.5">Da approvare</p>
            </div>
            {stats.pendingReviews > 0 && (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-orange-100 text-orange-700 text-xs font-semibold rounded-full w-fit">
                <span className="w-1.5 h-1.5 bg-orange-500 rounded-full animate-pulse" />
                In attesa
              </span>
            )}
          </div>

          {/* Lavoro da approvare */}
          <div className={`bg-white rounded-xl border shadow-sm p-5 flex flex-col gap-3 ${stats.pendingJobs > 0 ? 'border-cyan-200' : 'border-gray-100'}`}>
            <div className={`p-2.5 rounded-lg w-fit ${stats.pendingJobs > 0 ? 'bg-cyan-50' : 'bg-gray-50'}`}>
              <Briefcase className={`w-5 h-5 ${stats.pendingJobs > 0 ? 'text-cyan-600' : 'text-gray-400'}`} />
            </div>
            <div>
              <p className={`text-2xl font-bold ${stats.pendingJobs > 0 ? 'text-cyan-700' : 'text-gray-900'}`}>
                {stats.pendingJobs.toLocaleString('it-IT')}
              </p>
              <p className="text-sm font-medium text-gray-600 mt-0.5">Lavoro</p>
              <p className="text-xs text-gray-400 mt-0.5">Annunci da approvare</p>
            </div>
            {stats.pendingJobs > 0 && (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-cyan-100 text-cyan-700 text-xs font-semibold rounded-full w-fit">
                <span className="w-1.5 h-1.5 bg-cyan-500 rounded-full animate-pulse" />
                In attesa
              </span>
            )}
          </div>

          {/* Annunci da approvare */}
          <div className={`bg-white rounded-xl border shadow-sm p-5 flex flex-col gap-3 ${stats.pendingAds > 0 ? 'border-pink-200' : 'border-gray-100'}`}>
            <div className={`p-2.5 rounded-lg w-fit ${stats.pendingAds > 0 ? 'bg-pink-50' : 'bg-gray-50'}`}>
              <ShoppingBag className={`w-5 h-5 ${stats.pendingAds > 0 ? 'text-pink-600' : 'text-gray-400'}`} />
            </div>
            <div>
              <p className={`text-2xl font-bold ${stats.pendingAds > 0 ? 'text-pink-600' : 'text-gray-900'}`}>
                {stats.pendingAds.toLocaleString('it-IT')}
              </p>
              <p className="text-sm font-medium text-gray-600 mt-0.5">Annunci</p>
              <p className="text-xs text-gray-400 mt-0.5">Da approvare</p>
            </div>
            {stats.pendingAds > 0 && (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-pink-100 text-pink-700 text-xs font-semibold rounded-full w-fit">
                <span className="w-1.5 h-1.5 bg-pink-500 rounded-full animate-pulse" />
                In attesa
              </span>
            )}
          </div>

          {/* Aste da approvare */}
          <div className={`bg-white rounded-xl border shadow-sm p-5 flex flex-col gap-3 ${stats.pendingAuctions > 0 ? 'border-orange-200' : 'border-gray-100'}`}>
            <div className={`p-2.5 rounded-lg w-fit ${stats.pendingAuctions > 0 ? 'bg-orange-50' : 'bg-gray-50'}`}>
              <Gavel className={`w-5 h-5 ${stats.pendingAuctions > 0 ? 'text-orange-600' : 'text-gray-400'}`} />
            </div>
            <div>
              <p className={`text-2xl font-bold ${stats.pendingAuctions > 0 ? 'text-orange-600' : 'text-gray-900'}`}>
                {stats.pendingAuctions.toLocaleString('it-IT')}
              </p>
              <p className="text-sm font-medium text-gray-600 mt-0.5">Aste</p>
              <p className="text-xs text-gray-400 mt-0.5">Da approvare</p>
            </div>
            {stats.pendingAuctions > 0 && (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-orange-100 text-orange-700 text-xs font-semibold rounded-full w-fit">
                <span className="w-1.5 h-1.5 bg-orange-500 rounded-full animate-pulse" />
                In attesa
              </span>
            )}
          </div>

          {/* Segnalazioni aperte */}
          <div className={`bg-white rounded-xl border shadow-sm p-5 flex flex-col gap-3 ${stats.pendingReports > 0 ? 'border-red-200' : 'border-gray-100'}`}>
            <div className={`p-2.5 rounded-lg w-fit ${stats.pendingReports > 0 ? 'bg-red-50' : 'bg-gray-50'}`}>
              <AlertTriangle className={`w-5 h-5 ${stats.pendingReports > 0 ? 'text-red-500' : 'text-gray-400'}`} />
            </div>
            <div>
              <p className={`text-2xl font-bold ${stats.pendingReports > 0 ? 'text-red-600' : 'text-gray-900'}`}>
                {stats.pendingReports.toLocaleString('it-IT')}
              </p>
              <p className="text-sm font-medium text-gray-600 mt-0.5">Segnalazioni</p>
              <p className="text-xs text-gray-400 mt-0.5">Aperte</p>
            </div>
            {stats.pendingReports > 0 && (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-red-100 text-red-700 text-xs font-semibold rounded-full w-fit">
                <span className="w-1.5 h-1.5 bg-red-500 rounded-full animate-pulse" />
                Da verificare
              </span>
            )}
          </div>
        </div>
      </section>

      {/* Sezione: Utenti */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <Users className="w-4 h-4" /> Utenti
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <StatCard
            title="Utenti Iscritti"
            value={stats.totalUsers}
            subtitle={period !== null ? `Registrati negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Esclusi amministratori'}
            icon={Users}
            iconBg="bg-blue-50"
            iconColor="text-blue-600"
          />
          <StatCard
            title="Utenti in Prova"
            value={stats.trialUsers}
            subtitle="Stato attuale"
            icon={Clock}
            iconBg="bg-amber-50"
            iconColor="text-amber-600"
          />
          <StatCard
            title="Abbonamenti Attivi"
            value={stats.activeSubscriptions}
            subtitle="Stato attuale — business e privati"
            icon={CreditCard}
            iconBg="bg-teal-50"
            iconColor="text-teal-600"
          />
          <StatCard
            title="Abbonamenti in Prova"
            value={stats.trialSubscriptions}
            subtitle="Stato attuale"
            icon={CreditCard}
            iconBg="bg-orange-50"
            iconColor="text-orange-500"
          />
        </div>
      </section>

      {/* Sezione: Recensioni */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <Star className="w-4 h-4" /> Recensioni
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <StatCard
            title="Recensioni"
            value={stats.totalReviews}
            subtitle={period !== null ? `Pubblicate negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Totale storico'}
            icon={Star}
            iconBg="bg-yellow-50"
            iconColor="text-yellow-500"
            badge={stats.pendingReviews > 0 ? { label: 'in attesa', value: stats.pendingReviews, color: 'bg-orange-100 text-orange-700' } : undefined}
            breakdown={[
              { label: 'approvate', value: stats.totalReviews - stats.pendingReviews },
              { label: 'in attesa (totale)', value: stats.pendingReviews },
            ]}
          />
        </div>
      </section>

      {/* Sezione: Lavoro */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <Briefcase className="w-4 h-4" /> Lavoro
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <StatCard
            title="Trova Lavoro"
            value={stats.totalJobPostings}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Offerte pubblicate da aziende'}
            icon={Briefcase}
            iconBg="bg-cyan-50"
            iconColor="text-cyan-600"
          />
          <StatCard
            title="Cerca Lavoro"
            value={stats.totalJobSeekers}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Profili candidati attivi'}
            icon={Search}
            iconBg="bg-sky-50"
            iconColor="text-sky-600"
          />
        </div>
      </section>

      {/* Sezione: Annunci */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <ShoppingBag className="w-4 h-4" /> Annunci
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <StatCard
            title="Annunci Vendita"
            value={stats.adsSell}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Tipo: Vendo'}
            icon={ShoppingBag}
            iconBg="bg-pink-50"
            iconColor="text-pink-600"
          />
          <StatCard
            title="Annunci Cerco"
            value={stats.adsBuy}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Tipo: Cerco'}
            icon={Search}
            iconBg="bg-violet-50"
            iconColor="text-violet-600"
          />
          <StatCard
            title="Annunci Regalo"
            value={stats.adsGift}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Tipo: Regalo'}
            icon={Gift}
            iconBg="bg-rose-50"
            iconColor="text-rose-600"
          />
          <StatCard
            title="Aste"
            value={stats.totalAuctions}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Tutte le aste'}
            icon={Gavel}
            iconBg="bg-orange-50"
            iconColor="text-orange-600"
          />
        </div>
      </section>

      {/* Sezione: Solidarietà */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <Heart className="w-4 h-4" /> Solidarietà
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <StatCard
            title="Totale in Beneficienza"
            value={solidarityFormatted}
            subtitle={period !== null ? `Documenti negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Cifra totale destinata alle organizzazioni'}
            icon={Heart}
            iconBg="bg-red-50"
            iconColor="text-red-500"
          />
        </div>
      </section>

      {/* Sezione: Attività Commerciali */}
      <section>
        <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-2">
          <Building2 className="w-4 h-4" /> Attivita' Commerciali
        </h3>

        {/* Riquadro totale con breakdown visivo */}
        <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-5 mb-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <p className="text-3xl font-bold text-gray-900">{stats.totalBusinesses.toLocaleString('it-IT')}</p>
              <p className="text-sm font-medium text-gray-600 mt-0.5">Attivita' totali sulla piattaforma</p>
              {period !== null && (
                <p className="text-xs text-gray-400 mt-0.5">Negli ultimi {period === 1 ? 'giorno' : `${period} giorni`}</p>
              )}
            </div>
            {/* Barre proporzionali */}
            {stats.totalBusinesses > 0 && (
              <div className="flex-1 max-w-sm space-y-2">
                {[
                  { label: 'Importate', value: stats.importedBusinesses, color: 'bg-gray-400' },
                  { label: 'Aggiunte utenti', value: stats.userAddedBusinesses, color: 'bg-sky-400' },
                  { label: 'Iscritte', value: stats.selfRegisteredBusinesses, color: 'bg-blue-500' },
                  { label: 'Rivendicate', value: stats.claimedBusinesses, color: 'bg-green-500' },
                ].map(({ label, value, color }) => {
                  const pct = stats.totalBusinesses > 0 ? Math.round((value / stats.totalBusinesses) * 100) : 0;
                  return (
                    <div key={label} className="flex items-center gap-2">
                      <span className="text-xs text-gray-500 w-28 flex-shrink-0">{label}</span>
                      <div className="flex-1 bg-gray-100 rounded-full h-1.5">
                        <div className={`${color} h-1.5 rounded-full transition-all duration-500`} style={{ width: `${pct}%` }} />
                      </div>
                      <span className="text-xs font-semibold text-gray-700 w-8 text-right">{value.toLocaleString('it-IT')}</span>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard
            title="Importate"
            value={stats.importedBusinesses}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Da OSM / fonti esterne'}
            icon={Building2}
            iconBg="bg-gray-50"
            iconColor="text-gray-500"
          />
          <StatCard
            title="Aggiunte da Utente"
            value={stats.userAddedBusinesses}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Inserite manualmente dagli utenti'}
            icon={UserCheck}
            iconBg="bg-sky-50"
            iconColor="text-sky-600"
          />
          <StatCard
            title="Iscritte da Sole"
            value={stats.selfRegisteredBusinesses}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Registrazione diretta'}
            icon={Building2}
            iconBg="bg-blue-50"
            iconColor="text-blue-600"
          />
          <StatCard
            title="Rivendicate"
            value={stats.claimedBusinesses}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Scheda rivendicata dal proprietario'}
            icon={UserCheck}
            iconBg="bg-green-50"
            iconColor="text-green-600"
            badge={stats.claimedBusinesses > 0 && stats.totalBusinesses > 0 ? {
              label: 'del totale',
              value: `${Math.round((stats.claimedBusinesses / stats.totalBusinesses) * 100)}%`,
              color: 'bg-green-100 text-green-700'
            } : undefined}
          />
        </div>

        {/* Sedi */}
        <div className="mt-4 grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatCard
            title="Sedi Registrate"
            value={stats.totalLocations}
            subtitle={period !== null ? `Negli ultimi ${period === 1 ? 'giorno' : `${period} giorni`}` : 'Sedi di aziende con account'}
            icon={Building2}
            iconBg="bg-teal-50"
            iconColor="text-teal-600"
          />
        </div>
      </section>

    </div>
  );
}
