import { useState, useEffect } from 'react';
import { Heart, FileText, Download, Calendar, Euro, Users, TrendingUp, Clock, Building } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface SolidarityDocument {
  id: string;
  document_type: 'revenue' | 'donation';
  title: string;
  description: string | null;
  file_url: string;
  year: number;
  amount: number | null;
  recipient: string | null;
  created_at: string;
  profiles: {
    full_name: string;
  };
}

interface SubscriptionStats {
  totalActive: number;
  customerMonthly: number;
  customerYearly: number;
  businessMonthly: number;
  businessYearly: number;
  trialUsers: number;
}

export function SolidarityPage() {
  const [documents, setDocuments] = useState<SolidarityDocument[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedYear, setSelectedYear] = useState<number | 'all'>('all');
  const [totalRevenue, setTotalRevenue] = useState<number>(0);
  const [loadingRevenue, setLoadingRevenue] = useState(true);
  const [subscriptionStats, setSubscriptionStats] = useState<SubscriptionStats>({
    totalActive: 0,
    customerMonthly: 0,
    customerYearly: 0,
    businessMonthly: 0,
    businessYearly: 0,
    trialUsers: 0,
  });
  const [loadingStats, setLoadingStats] = useState(true);

  useEffect(() => {
    loadDocuments();
    loadRevenue();
    loadSubscriptionStats();
  }, []);

  const loadRevenue = async () => {
    try {
      setLoadingRevenue(true);
      // Usa la funzione RPC per ottenere il fatturato totale
      const { data, error } = await supabase.rpc('get_total_revenue');

      if (error) throw error;

      setTotalRevenue(parseFloat(data || 0));
    } catch (error) {
      console.error('Error loading revenue:', error);
    } finally {
      setLoadingRevenue(false);
    }
  };

  const loadSubscriptionStats = async () => {
    try {
      setLoadingStats(true);

      // Usa la funzione RPC per ottenere le statistiche aggregate
      const { data, error } = await supabase.rpc('get_subscription_stats');

      if (error) throw error;

      if (data) {
        setSubscriptionStats({
          totalActive: data.totalActive || 0,
          customerMonthly: data.customerMonthly || 0,
          customerYearly: data.customerYearly || 0,
          businessMonthly: data.businessMonthly || 0,
          businessYearly: data.businessYearly || 0,
          trialUsers: data.trialUsers || 0,
        });
      }
    } catch (error) {
      console.error('Error loading subscription stats:', error);
    } finally {
      setLoadingStats(false);
    }
  };

  const loadDocuments = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('solidarity_documents')
        .select(`
          *,
          profiles:uploaded_by(full_name)
        `)
        .order('year', { ascending: false })
        .order('created_at', { ascending: false });

      if (error) throw error;
      setDocuments(data || []);
    } catch (error) {
      console.error('Error loading documents:', error);
    } finally {
      setLoading(false);
    }
  };

  const years = [...new Set(documents.map((d) => d.year))].sort((a, b) => b - a);

  const filteredDocuments =
    selectedYear === 'all'
      ? documents
      : documents.filter((d) => d.year === selectedYear);

  const revenueDocuments = filteredDocuments.filter((d) => d.document_type === 'revenue');
  const donationDocuments = filteredDocuments.filter((d) => d.document_type === 'donation');

  const totalDonations = donationDocuments.reduce(
    (sum, doc) => sum + (doc.amount || 0),
    0
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero */}
      <section className="bg-white border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20 text-center">
          <div className="inline-flex items-center gap-2 bg-green-50 text-green-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
            <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse"></div>
            10% del fatturato donato ogni anno
          </div>
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-4">
            Solidarieta <span className="text-green-600">Lhimo</span>
          </h1>
          <p className="text-lg text-gray-500 max-w-2xl mx-auto mb-8">
            Doniamo il 10% del nostro fatturato annuale a organizzazioni no profit e progetti sociali scelti dagli iscritti
          </p>
          <div className="flex flex-wrap justify-center gap-4">
            {[
              { text: 'Trasparenza totale', color: 'bg-green-50 text-green-700' },
              { text: 'Scelto dagli iscritti', color: 'bg-blue-50 text-blue-700' },
              { text: 'Documenti pubblici', color: 'bg-gray-100 text-gray-700' },
            ].map(({ text, color }) => (
              <span key={text} className={`inline-flex items-center gap-1.5 text-xs font-semibold px-3 py-1.5 rounded-full ${color}`}>
                <div className="w-1.5 h-1.5 rounded-full bg-current opacity-60"></div>
                {text}
              </span>
            ))}
          </div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 py-12">

        {/* Revenue and Solidarity Counters */}
        <div className="bg-white rounded-xl shadow-lg p-8 mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6 text-center">
            Contatori in Tempo Reale
          </h2>

          {loadingRevenue ? (
            <div className="text-center py-8">
              <div className="animate-spin w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full mx-auto"></div>
              <p className="text-gray-600 mt-4">Caricamento dati...</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {/* Fatturato Counter */}
              <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-8 text-center border-2 border-blue-200 shadow-md">
                <div className="flex items-center justify-center mb-4">
                  <div className="bg-blue-500 p-4 rounded-full">
                    <Euro className="w-8 h-8 text-white" />
                  </div>
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">Fatturato Totale</h3>
                <div className="text-4xl md:text-5xl font-bold text-blue-600 mb-2">
                  €{totalRevenue.toLocaleString('it-IT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </div>
                <p className="text-sm text-gray-600">Da tutti gli abbonamenti attivi</p>
              </div>

              {/* Solidarietà Counter */}
              <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-8 text-center border-2 border-green-200 shadow-md">
                <div className="flex items-center justify-center mb-4">
                  <div className="bg-green-500 p-4 rounded-full">
                    <Heart className="w-8 h-8 text-white" />
                  </div>
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">Solidarietà (10%)</h3>
                <div className="text-4xl md:text-5xl font-bold text-green-600 mb-2">
                  €{(totalRevenue * 0.1).toLocaleString('it-IT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </div>
                <p className="text-sm text-gray-600">Destinato alla beneficenza</p>
              </div>
            </div>
          )}

          <div className="mt-6 space-y-3">
            <div className="text-center text-sm text-gray-600 bg-blue-50 rounded-lg p-4">
              <p className="font-medium">
                Questi contatori si aggiornano automaticamente ad ogni nuovo abbonamento ricevuto dalla piattaforma
              </p>
            </div>
            <div className="text-center text-sm text-gray-700 bg-yellow-50 border-2 border-yellow-200 rounded-lg p-4">
              <p className="font-semibold text-yellow-900 mb-1">
                Nota Importante
              </p>
              <p>
                I contatori <span className="font-semibold">Fatturato Totale</span> e <span className="font-semibold">Solidarietà</span> saranno a zero per il primo mese perché la prova è gratuita per tutti gli utenti
              </p>
            </div>
          </div>
        </div>

        {/* Subscription Statistics */}
        <div className="bg-white rounded-xl shadow-lg p-8 mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6 text-center">
            Statistiche Abbonamenti
          </h2>

          {loadingStats ? (
            <div className="text-center py-8">
              <div className="animate-spin w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full mx-auto"></div>
              <p className="text-gray-600 mt-4">Caricamento statistiche...</p>
            </div>
          ) : (
            <>
              {/* Total Active Subscriptions */}
              <div className="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-8 text-center border-2 border-purple-200 shadow-md mb-6">
                <div className="flex items-center justify-center mb-4">
                  <div className="bg-purple-500 p-4 rounded-full">
                    <Users className="w-10 h-10 text-white" />
                  </div>
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">Utenti Abbonati Totali</h3>
                <div className="text-5xl md:text-6xl font-bold text-purple-600 mb-2">
                  {subscriptionStats.totalActive.toLocaleString('it-IT')}
                </div>
                <p className="text-sm text-gray-600">Abbonamenti attivi sulla piattaforma</p>
                {subscriptionStats.trialUsers > 0 && (
                  <div className="mt-4 bg-purple-200 rounded-lg p-3">
                    <p className="text-sm font-semibold text-purple-900">
                      + {subscriptionStats.trialUsers} utenti in prova gratuita
                    </p>
                  </div>
                )}
              </div>

              {/* Subscription Type Breakdown */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                {/* Customer Subscriptions */}
                <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-xl p-6 border-2 border-blue-200 shadow-md">
                  <div className="flex items-center justify-center mb-4">
                    <div className="bg-blue-500 p-3 rounded-full">
                      <Users className="w-6 h-6 text-white" />
                    </div>
                  </div>
                  <h3 className="text-lg font-bold text-gray-900 mb-4 text-center">Abbonamenti Clienti</h3>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between bg-white rounded-lg p-4 shadow-sm">
                      <div className="flex items-center gap-2">
                        <Clock className="w-5 h-5 text-blue-600" />
                        <span className="font-medium text-gray-700">Mensili</span>
                      </div>
                      <span className="text-2xl font-bold text-blue-600">
                        {subscriptionStats.customerMonthly}
                      </span>
                    </div>
                    <div className="flex items-center justify-between bg-white rounded-lg p-4 shadow-sm">
                      <div className="flex items-center gap-2">
                        <Calendar className="w-5 h-5 text-cyan-600" />
                        <span className="font-medium text-gray-700">Annuali</span>
                      </div>
                      <span className="text-2xl font-bold text-cyan-600">
                        {subscriptionStats.customerYearly}
                      </span>
                    </div>
                    <div className="bg-blue-100 rounded-lg p-3 mt-4">
                      <p className="text-center font-bold text-blue-900 text-lg">
                        Totale: {subscriptionStats.customerMonthly + subscriptionStats.customerYearly}
                      </p>
                    </div>
                  </div>
                </div>

                {/* Business Subscriptions */}
                <div className="bg-gradient-to-br from-orange-50 to-amber-50 rounded-xl p-6 border-2 border-orange-200 shadow-md">
                  <div className="flex items-center justify-center mb-4">
                    <div className="bg-orange-500 p-3 rounded-full">
                      <Building className="w-6 h-6 text-white" />
                    </div>
                  </div>
                  <h3 className="text-lg font-bold text-gray-900 mb-4 text-center">Abbonamenti Aziende</h3>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between bg-white rounded-lg p-4 shadow-sm">
                      <div className="flex items-center gap-2">
                        <Clock className="w-5 h-5 text-orange-600" />
                        <span className="font-medium text-gray-700">Mensili</span>
                      </div>
                      <span className="text-2xl font-bold text-orange-600">
                        {subscriptionStats.businessMonthly}
                      </span>
                    </div>
                    <div className="flex items-center justify-between bg-white rounded-lg p-4 shadow-sm">
                      <div className="flex items-center gap-2">
                        <Calendar className="w-5 h-5 text-amber-600" />
                        <span className="font-medium text-gray-700">Annuali</span>
                      </div>
                      <span className="text-2xl font-bold text-amber-600">
                        {subscriptionStats.businessYearly}
                      </span>
                    </div>
                    <div className="bg-orange-100 rounded-lg p-3 mt-4">
                      <p className="text-center font-bold text-orange-900 text-lg">
                        Totale: {subscriptionStats.businessMonthly + subscriptionStats.businessYearly}
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Percentage Breakdown */}
              <div className="bg-gradient-to-r from-indigo-50 to-purple-50 rounded-xl p-6 border-2 border-indigo-200">
                <h3 className="text-lg font-bold text-gray-900 mb-4 text-center flex items-center justify-center gap-2">
                  <TrendingUp className="w-5 h-5 text-indigo-600" />
                  Distribuzione Abbonamenti
                </h3>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div className="bg-white rounded-lg p-4 text-center shadow-sm">
                    <div className="text-2xl font-bold text-blue-600 mb-1">
                      {subscriptionStats.totalActive > 0
                        ? ((subscriptionStats.customerMonthly / subscriptionStats.totalActive) * 100).toFixed(1)
                        : 0}%
                    </div>
                    <div className="text-xs text-gray-600">Clienti Mensili</div>
                  </div>
                  <div className="bg-white rounded-lg p-4 text-center shadow-sm">
                    <div className="text-2xl font-bold text-cyan-600 mb-1">
                      {subscriptionStats.totalActive > 0
                        ? ((subscriptionStats.customerYearly / subscriptionStats.totalActive) * 100).toFixed(1)
                        : 0}%
                    </div>
                    <div className="text-xs text-gray-600">Clienti Annuali</div>
                  </div>
                  <div className="bg-white rounded-lg p-4 text-center shadow-sm">
                    <div className="text-2xl font-bold text-orange-600 mb-1">
                      {subscriptionStats.totalActive > 0
                        ? ((subscriptionStats.businessMonthly / subscriptionStats.totalActive) * 100).toFixed(1)
                        : 0}%
                    </div>
                    <div className="text-xs text-gray-600">Aziende Mensili</div>
                  </div>
                  <div className="bg-white rounded-lg p-4 text-center shadow-sm">
                    <div className="text-2xl font-bold text-amber-600 mb-1">
                      {subscriptionStats.totalActive > 0
                        ? ((subscriptionStats.businessYearly / subscriptionStats.totalActive) * 100).toFixed(1)
                        : 0}%
                    </div>
                    <div className="text-xs text-gray-600">Aziende Annuali</div>
                  </div>
                </div>
              </div>
            </>
          )}

          <div className="mt-6 text-center text-sm text-gray-600 bg-indigo-50 rounded-lg p-4">
            <p className="font-medium">
              Questi dati vengono aggiornati in tempo reale e rappresentano tutti gli abbonamenti attivi sulla piattaforma
            </p>
          </div>
        </div>

        {/* Statistics */}
        {totalDonations > 0 && (
          <div className="bg-white rounded-xl shadow-lg p-8 mb-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6 text-center">
              Statistiche Donazioni
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-lg p-6 text-center">
                <div className="text-3xl font-bold text-green-600 mb-2">
                  €{totalDonations.toLocaleString('it-IT', { minimumFractionDigits: 2 })}
                </div>
                <div className="text-gray-600 font-medium">Totale Donato</div>
              </div>
              <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg p-6 text-center">
                <div className="text-3xl font-bold text-blue-600 mb-2">
                  {donationDocuments.length}
                </div>
                <div className="text-gray-600 font-medium">Donazioni Effettuate</div>
              </div>
              <div className="bg-gradient-to-br from-orange-50 to-orange-100 rounded-lg p-6 text-center">
                <div className="text-3xl font-bold text-orange-600 mb-2">
                  {years.length}
                </div>
                <div className="text-gray-600 font-medium">
                  {years.length === 1 ? 'Anno' : 'Anni'} di Solidarietà
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Year Filter */}
        {years.length > 1 && (
          <div className="bg-white rounded-lg shadow-sm p-4 mb-8">
            <div className="flex flex-wrap gap-2">
              <button
                onClick={() => setSelectedYear('all')}
                className={`px-6 py-2 rounded-lg font-medium transition-all ${
                  selectedYear === 'all'
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                }`}
              >
                Tutti gli anni
              </button>
              {years.map((year) => (
                <button
                  key={year}
                  onClick={() => setSelectedYear(year)}
                  className={`px-6 py-2 rounded-lg font-medium transition-all ${
                    selectedYear === year
                      ? 'bg-blue-600 text-white'
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  }`}
                >
                  {year}
                </button>
              ))}
            </div>
          </div>
        )}

        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full mx-auto"></div>
            <p className="text-gray-600 mt-4">Caricamento documenti...</p>
          </div>
        ) : (
          <div className="space-y-8">
            {/* Revenue Documents */}
            {revenueDocuments.length > 0 && (
              <div className="bg-white rounded-xl shadow-lg p-8">
                <div className="flex items-center gap-3 mb-6">
                  <div className="bg-blue-100 p-3 rounded-lg">
                    <FileText className="w-6 h-6 text-blue-600" />
                  </div>
                  <h2 className="text-2xl font-bold text-gray-900">
                    Documenti Fatturato
                  </h2>
                </div>
                <div className="grid grid-cols-1 gap-4">
                  {revenueDocuments.map((doc) => (
                    <DocumentCard key={doc.id} document={doc} />
                  ))}
                </div>
              </div>
            )}

            {/* Donation Documents */}
            {donationDocuments.length > 0 && (
              <div className="bg-white rounded-xl shadow-lg p-8">
                <div className="flex items-center gap-3 mb-6">
                  <div className="bg-green-100 p-3 rounded-lg">
                    <Heart className="w-6 h-6 text-green-600" />
                  </div>
                  <h2 className="text-2xl font-bold text-gray-900">
                    Donazioni Effettuate
                  </h2>
                </div>
                <div className="grid grid-cols-1 gap-4">
                  {donationDocuments.map((doc) => (
                    <DocumentCard key={doc.id} document={doc} />
                  ))}
                </div>
              </div>
            )}

            {filteredDocuments.length === 0 && (
              <div className="bg-white rounded-xl shadow-lg p-12 text-center">
                <FileText className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                <p className="text-xl text-gray-600">
                  {selectedYear === 'all'
                    ? 'Nessun documento ancora caricato'
                    : `Nessun documento per l'anno ${selectedYear}`}
                </p>
                <p className="text-gray-500 mt-2">
                  I documenti verranno pubblicati non appena disponibili
                </p>
              </div>
            )}
          </div>
        )}

        {/* Future Activities Section */}
        <div className="bg-gradient-to-r from-blue-100 to-green-100 rounded-xl shadow-lg p-8 mt-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-4 text-center">
            Prossimamente
          </h2>
          <p className="text-center text-gray-700 text-lg">
            In questa sezione pubblicheremo anche informazioni su attività no profit,
            eventi di beneficenza e iniziative solidali a cui partecipiamo o che sosteniamo.
          </p>
        </div>
      </div>
    </div>
  );
}

function DocumentCard({ document }: { document: SolidarityDocument }) {
  return (
    <div className="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <div className="flex items-center gap-3 mb-2">
            <span
              className={`px-3 py-1 rounded-full text-sm font-bold ${
                document.document_type === 'revenue'
                  ? 'bg-blue-100 text-blue-700'
                  : 'bg-green-100 text-green-700'
              }`}
            >
              {document.document_type === 'revenue' ? '📊 Fatturato' : '❤️ Donazione'}
            </span>
            <span className="flex items-center gap-1 text-sm text-gray-600">
              <Calendar className="w-4 h-4" />
              {document.year}
            </span>
          </div>

          <h3 className="text-xl font-bold text-gray-900 mb-2">
            {document.title}
          </h3>

          {document.description && (
            <p className="text-gray-600 mb-3">{document.description}</p>
          )}

          <div className="flex flex-wrap gap-4 text-sm text-gray-600">
            {document.amount && (
              <div className="flex items-center gap-1">
                <Euro className="w-4 h-4" />
                <span className="font-medium">
                  €{document.amount.toLocaleString('it-IT', { minimumFractionDigits: 2 })}
                </span>
              </div>
            )}
            {document.recipient && (
              <div>
                <span className="font-medium">Destinatario:</span> {document.recipient}
              </div>
            )}
          </div>

          <div className="text-xs text-gray-500 mt-3">
            Caricato da {document.profiles.full_name} il{' '}
            {new Date(document.created_at).toLocaleDateString('it-IT')}
          </div>
        </div>

        <a
          href={document.file_url}
          target="_blank"
          rel="noopener noreferrer"
          className="ml-4 flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
        >
          <Download className="w-4 h-4" />
          Scarica
        </a>
      </div>
    </div>
  );
}
