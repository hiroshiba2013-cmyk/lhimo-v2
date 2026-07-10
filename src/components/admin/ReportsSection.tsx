import { useState } from 'react';
import { AlertTriangle, CheckCircle, XCircle, Eye, Search, FileText, MessageSquare, Store, Star, ShoppingBag, Briefcase } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface Report {
  id: string;
  reason: string;
  description: string;
  status: string;
  created_at: string;
  reported_entity_type: string;
  reported_entity_id: string;
  family_member_id: string | null;
  reporter: {
    full_name: string;
    nickname: string | null;
    email: string;
  };
  family_member?: {
    first_name: string;
    last_name: string;
    nickname: string | null;
  } | null;
  entity_name?: string;
}

interface ClassifiedAdDetails {
  id: string;
  title: string;
  description: string;
  price: number | null;
  category: string;
}

interface ReviewDetails {
  id: string;
  title: string;
  content: string;
  overall_rating: number;
  business_location?: {
    name: string;
  } | null;
  unclaimed_business_location?: {
    name: string;
  } | null;
}

interface BusinessDetails {
  id: string;
  name: string;
  description: string | null;
  category: string | null;
  address: string | null;
  city: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
}

interface JobPostingDetails {
  id: string;
  title: string;
  description: string;
  location: string | null;
  position_type: string | null;
  company_name: string | null;
  experience_level: string | null;
}

interface ReportsSectionProps {
  reports: Report[];
  onReload: () => Promise<void>;
}

type FilterType = 'all' | 'classified_ad' | 'review' | 'business' | 'job_posting';

export function ReportsSection({ reports, onReload }: ReportsSectionProps) {
  const { showToast } = useToast();
  const [filterType, setFilterType] = useState<FilterType>('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [showSearch, setShowSearch] = useState(false);
  const [selectedReport, setSelectedReport] = useState<Report | null>(null);
  const [entityDetails, setEntityDetails] = useState<ClassifiedAdDetails | ReviewDetails | BusinessDetails | JobPostingDetails | null>(null);
  const [loadingDetails, setLoadingDetails] = useState(false);

  const handleResolveReport = async (reportId: string) => {
    try {
      const { error } = await supabase
        .from('reports')
        .update({
          status: 'resolved',
          reviewed_at: new Date().toISOString()
        })
        .eq('id', reportId);

      if (error) throw error;

      showToast('Segnalazione risolta', 'info');
      setSelectedReport(null);
      await onReload();
    } catch (error: any) {
      console.error('Error resolving report:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleDismissReport = async (reportId: string) => {
    try {
      const { error } = await supabase
        .from('reports')
        .update({
          status: 'dismissed',
          reviewed_at: new Date().toISOString()
        })
        .eq('id', reportId);

      if (error) throw error;

      showToast('Segnalazione respinta', 'info');
      setSelectedReport(null);
      await onReload();
    } catch (error: any) {
      console.error('Error dismissing report:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const viewReportDetails = async (report: Report) => {
    setSelectedReport(report);
    setLoadingDetails(true);
    setEntityDetails(null);

    try {
      if (report.reported_entity_type === 'classified_ad') {
        const { data, error } = await supabase
          .from('classified_ads')
          .select('id, title, description, price, category')
          .eq('id', report.reported_entity_id)
          .maybeSingle();

        if (error) throw error;
        setEntityDetails(data);
      } else if (report.reported_entity_type === 'review') {
        const { data, error } = await supabase
          .from('reviews')
          .select(`
            id,
            title,
            content,
            overall_rating,
            business_location:business_locations(name),
            unclaimed_business_location:unclaimed_business_locations(name)
          `)
          .eq('id', report.reported_entity_id)
          .maybeSingle();

        if (error) throw error;
        setEntityDetails(data);
      } else if (report.reported_entity_type === 'business') {
        // Try claimed businesses first
        let { data, error } = await supabase
          .from('businesses')
          .select('id, name, description, category, address, city, phone, email, website')
          .eq('id', report.reported_entity_id)
          .maybeSingle();

        if (!data && !error) {
          // Try business locations
          const locationResult = await supabase
            .from('business_locations')
            .select('id, name, description, address, city, phone, email, website')
            .eq('id', report.reported_entity_id)
            .maybeSingle();

          if (!locationResult.error && locationResult.data) {
            data = { ...locationResult.data, category: null };
          }
        }

        if (!data) {
          // Try unclaimed businesses
          const unclaimedResult = await supabase
            .from('unclaimed_business_locations')
            .select('id, name, description, category, address, city, phone, email, website')
            .eq('id', report.reported_entity_id)
            .maybeSingle();

          if (!unclaimedResult.error) {
            data = unclaimedResult.data;
          }
        }

        setEntityDetails(data);
      } else if (report.reported_entity_type === 'job_posting') {
        const { data, error } = await supabase
          .from('job_postings')
          .select('id, title, description, location, position_type, company_name, experience_level')
          .eq('id', report.reported_entity_id)
          .maybeSingle();

        if (error) throw error;
        setEntityDetails(data);
      }
    } catch (error: any) {
      console.error('Error loading entity details:', error);
      showToast(`Errore nel caricamento dei dettagli: ${error.message}`, 'error');
    } finally {
      setLoadingDetails(false);
    }
  };

  const filteredReports = reports.filter(report => {
    const matchesType = filterType === 'all' || report.reported_entity_type === filterType;
    const matchesSearch = searchTerm === '' ||
      getReporterName(report).toLowerCase().includes(searchTerm.toLowerCase()) ||
      report.reporter.email.toLowerCase().includes(searchTerm.toLowerCase());

    return matchesType && matchesSearch;
  });

  const pendingReports = filteredReports.filter(r => r.status === 'pending');
  const reviewedReports = filteredReports.filter(r => ['resolved', 'dismissed'].includes(r.status));

  const getEntityTypeBadgeColor = (type: string) => {
    switch (type) {
      case 'classified_ad': return 'bg-blue-100 text-blue-800';
      case 'review': return 'bg-yellow-100 text-yellow-800';
      case 'business': return 'bg-green-100 text-green-800';
      case 'job_posting': return 'bg-orange-100 text-orange-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getEntityTypeLabel = (type: string) => {
    switch (type) {
      case 'classified_ad': return 'Annuncio';
      case 'review': return 'Recensione';
      case 'business': return 'Attività';
      case 'job_posting': return 'Offerta Lavoro';
      default: return type;
    }
  };

  const getReporterName = (report: Report) => {
    if (report.family_member) {
      return report.family_member.nickname || `${report.family_member.first_name} ${report.family_member.last_name}`;
    }
    return report.reporter.nickname || report.reporter.full_name;
  };

  const getReasonLabel = (reason: string) => {
    const reasonLabels: Record<string, string> = {
      // Review reasons
      'false_review': 'Recensione falsa o incentivata',
      'offensive': 'Linguaggio offensivo o discriminatorio',
      'defamation': 'Diffamazione o accuse infondate',
      'privacy': 'Violazione privacy',
      'spam': 'Spam o pubblicità ingannevole',
      'inappropriate': 'Contenuto inappropriato',
      'harassment': 'Molestie o bullismo',
      // Business reasons
      'fake_business': 'Attività inesistente o informazioni false',
      'duplicate': 'Attività duplicata',
      'wrong_info': 'Informazioni errate',
      'closed': 'Attività chiusa definitivamente',
      'wrong_category': 'Categoria errata',
      'illegal': 'Attività o prodotto illegale',
      // Classified ad reasons
      'fake': 'Annuncio o offerta falsa',
      'illegal_product': 'Prodotto illegale o contraffatto',
      'prohibited': 'Prodotto vietato',
      'already_sold': 'Prodotto già venduto',
      'scam': 'Truffa o schema piramidale',
      'copyright': 'Violazione copyright',
      'other': 'Altro'
    };
    return reasonLabels[reason] || reason;
  };

  return (
    <div className="space-y-6">

      {/* ── Hero header ── */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6 mb-6">
        {/* dot overlay */}
        <div
          className="absolute inset-0 opacity-5"
          style={{
            backgroundImage: 'radial-gradient(circle at 1px 1px, white 1px, transparent 0)',
            backgroundSize: '28px 28px',
          }}
        />

        <div className="relative z-10 flex flex-col md:flex-row md:items-start md:justify-between gap-4">
          {/* Left: labels + stats */}
          <div>
            <p className="text-gray-400 uppercase text-xs font-semibold tracking-widest mb-1">Moderazione</p>
            <h2 className="text-2xl font-bold text-white mb-3">Segnalazioni</h2>

            {/* Stat chips */}
            <div className="flex flex-wrap gap-2">
              <span className="bg-white/10 text-white rounded-xl px-3 py-1 text-sm font-medium">
                Totale: {filteredReports.length}
              </span>
              <span className="bg-red-500/20 text-red-300 rounded-xl px-3 py-1 text-sm font-medium">
                In sospeso: {pendingReports.length}
              </span>
              <span className="bg-green-500/20 text-green-300 rounded-xl px-3 py-1 text-sm font-medium">
                Revisionate: {reviewedReports.length}
              </span>
            </div>
          </div>

          {/* Right: search toggle */}
          <button
            onClick={() => setShowSearch(v => !v)}
            className="self-start bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl px-4 py-2 flex items-center gap-2 transition-colors text-sm font-medium"
          >
            <Search className="w-4 h-4" />
            {showSearch ? 'Nascondi ricerca' : 'Cerca'}
          </button>
        </div>

        {/* Search bar (toggled) */}
        {showSearch && (
          <div className="relative z-10 mt-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
              <input
                type="text"
                placeholder="Cerca per nome utente o email..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-white/10 border border-white/20 rounded-xl text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-white/30 text-sm"
              />
            </div>
          </div>
        )}

        {/* Filter tabs */}
        <div className="relative z-10 mt-4 flex flex-wrap gap-2">
          {(['all', 'classified_ad', 'review', 'business', 'job_posting'] as FilterType[]).map((type) => {
            const labels: Record<FilterType, string> = {
              all: 'Tutte',
              classified_ad: 'Annunci',
              review: 'Recensioni',
              business: 'Attività',
              job_posting: 'Lavoro',
            };
            const isActive = filterType === type;
            return (
              <button
                key={type}
                onClick={() => setFilterType(type)}
                className={`rounded-xl px-4 py-2 text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-gray-900 text-white'
                    : 'bg-white border border-gray-200 text-gray-600 hover:bg-gray-50'
                }`}
              >
                {labels[type]}
              </button>
            );
          })}
        </div>
      </div>

      {/* ── Pending reports ── */}
      <div>
        <h2 className="text-2xl font-bold text-gray-900 mb-4">
          Segnalazioni in Sospeso ({pendingReports.length})
        </h2>

        {pendingReports.length === 0 ? (
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-8 text-center">
            <AlertTriangle className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600">Nessuna segnalazione in sospeso</p>
          </div>
        ) : (
          <div className="space-y-4">
            {pendingReports.map((report) => (
              <div key={report.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow">
                <div className="flex justify-between items-start mb-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2 flex-wrap">
                      <span className={`rounded-full px-3 py-1 text-xs font-semibold ${getEntityTypeBadgeColor(report.reported_entity_type)}`}>
                        {getEntityTypeLabel(report.reported_entity_type)}
                      </span>
                      <span className="rounded-full px-3 py-1 text-xs font-semibold bg-red-100 text-red-800">
                        {getReasonLabel(report.reason)}
                      </span>
                      <span className="rounded-full px-3 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800">
                        In sospeso
                      </span>
                    </div>
                    {report.entity_name && (
                      <p className="text-base font-bold text-gray-900 mb-2 flex items-center gap-1">
                        {report.reported_entity_type === 'business' && <Store className="w-4 h-4 text-gray-700" />}
                        {report.reported_entity_type === 'classified_ad' && <ShoppingBag className="w-4 h-4 text-gray-700" />}
                        {report.reported_entity_type === 'review' && <Star className="w-4 h-4 text-gray-700" />}
                        {report.reported_entity_type === 'job_posting' && <Briefcase className="w-4 h-4 text-gray-700" />}
                        {report.entity_name}
                      </p>
                    )}
                    <p className="text-sm font-semibold text-gray-900">
                      Segnalato da: {getReporterName(report)}
                      {report.family_member && (
                        <span className="ml-2 text-xs font-normal text-gray-500">(membro famiglia di {report.reporter.nickname || report.reporter.full_name})</span>
                      )}
                    </p>
                    <p className="text-sm text-gray-600">
                      {report.reporter.email}
                    </p>
                    <p className="text-sm text-gray-500 mt-1">
                      {new Date(report.created_at).toLocaleDateString('it-IT', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </p>
                  </div>
                </div>

                <div className="bg-gray-50 rounded-lg p-4 mb-4">
                  <p className="text-sm font-semibold text-gray-700 mb-1">Motivazione:</p>
                  <p className="text-gray-700">{report.description || 'Nessuna descrizione fornita'}</p>
                </div>

                <div className="flex gap-2">
                  <button
                    onClick={() => viewReportDetails(report)}
                    className="flex-1 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center justify-center gap-2"
                  >
                    <Eye className="w-5 h-5" />
                    Visualizza Dettagli
                  </button>
                  <button
                    onClick={() => handleResolveReport(report.id)}
                    className="flex-1 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors flex items-center justify-center gap-2"
                  >
                    <CheckCircle className="w-5 h-5" />
                    Risolvi
                  </button>
                  <button
                    onClick={() => handleDismissReport(report.id)}
                    className="flex-1 bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors flex items-center justify-center gap-2"
                  >
                    <XCircle className="w-5 h-5" />
                    Respingi
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* ── Reviewed reports ── */}
      {reviewedReports.length > 0 && (
        <div>
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Segnalazioni Revisionate ({reviewedReports.length})
          </h2>
          <div className="space-y-4">
            {reviewedReports.slice(0, 20).map((report) => (
              <div key={report.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow">
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2 flex-wrap">
                      <span className={`rounded-full px-3 py-1 text-xs font-semibold ${getEntityTypeBadgeColor(report.reported_entity_type)}`}>
                        {getEntityTypeLabel(report.reported_entity_type)}
                      </span>
                      <span className="rounded-full px-3 py-1 text-xs font-semibold bg-red-100 text-red-800">
                        {getReasonLabel(report.reason)}
                      </span>
                      <span className={`rounded-full px-3 py-1 text-xs font-semibold ${
                        report.status === 'resolved'
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-200 text-gray-700'
                      }`}>
                        {report.status === 'resolved' ? 'Risolta' : 'Respinta'}
                      </span>
                    </div>
                    {report.entity_name && (
                      <p className="text-sm font-bold text-gray-900 mb-1 flex items-center gap-1">
                        {report.reported_entity_type === 'business' && <Store className="w-3 h-3 text-gray-700" />}
                        {report.reported_entity_type === 'classified_ad' && <ShoppingBag className="w-3 h-3 text-gray-700" />}
                        {report.reported_entity_type === 'review' && <Star className="w-3 h-3 text-gray-700" />}
                        {report.reported_entity_type === 'job_posting' && <Briefcase className="w-3 h-3 text-gray-700" />}
                        {report.entity_name}
                      </p>
                    )}
                    <p className="text-sm font-medium text-gray-900">
                      Segnalato da: {getReporterName(report)}
                      {report.family_member && (
                        <span className="ml-1 text-xs font-normal text-gray-500">(membro famiglia)</span>
                      )}
                    </p>
                    <p className="text-sm text-gray-600 mt-1">{report.description || 'Nessuna descrizione'}</p>
                    <p className="text-xs text-gray-500 mt-2">
                      {new Date(report.created_at).toLocaleDateString('it-IT')}
                    </p>
                  </div>
                  <button
                    onClick={() => viewReportDetails(report)}
                    className="ml-4 p-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
                    title="Visualizza dettagli"
                  >
                    <Eye className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ── Detail modal ── */}
      {selectedReport && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-gray-800 to-gray-900 text-white px-6 py-4 rounded-t-2xl flex items-center justify-between">
              <h3 className="text-xl font-bold text-white">Dettagli Segnalazione</h3>
              <button
                onClick={() => setSelectedReport(null)}
                className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              >
                <XCircle className="w-5 h-5 text-white" />
              </button>
            </div>

            <div className="p-6 space-y-6">
              <div className="bg-gray-50 rounded-lg p-4">
                <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                  <AlertTriangle className="w-5 h-5 text-red-600" />
                  Informazioni Segnalazione
                </h4>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="text-gray-600">Segnalato da:</span>
                    <p className="font-medium">
                      {getReporterName(selectedReport)}
                      {selectedReport.family_member && (
                        <span className="ml-1 text-sm font-normal text-gray-500">(membro famiglia di {selectedReport.reporter.nickname || selectedReport.reporter.full_name})</span>
                      )}
                    </p>
                  </div>
                  <div>
                    <span className="text-gray-600">Email:</span>
                    <p className="font-medium">{selectedReport.reporter.email}</p>
                  </div>
                  <div>
                    <span className="text-gray-600">Tipo contenuto:</span>
                    <p className="font-medium">{getEntityTypeLabel(selectedReport.reported_entity_type)}</p>
                  </div>
                  <div>
                    <span className="text-gray-600">Motivo:</span>
                    <p className="font-medium">{getReasonLabel(selectedReport.reason)}</p>
                  </div>
                  <div className="col-span-2">
                    <span className="text-gray-600">Data segnalazione:</span>
                    <p className="font-medium">
                      {new Date(selectedReport.created_at).toLocaleDateString('it-IT', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </p>
                  </div>
                  <div className="col-span-2">
                    <span className="text-gray-600">Descrizione:</span>
                    <p className="font-medium mt-1">{selectedReport.description || 'Nessuna descrizione fornita'}</p>
                  </div>
                </div>
              </div>

              {loadingDetails && (
                <div className="flex items-center justify-center py-8">
                  <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-red-600"></div>
                </div>
              )}

              {!loadingDetails && entityDetails && selectedReport.reported_entity_type === 'classified_ad' && (
                <div className="bg-blue-50 rounded-lg p-4 border border-blue-200">
                  <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                    <FileText className="w-5 h-5 text-blue-600" />
                    Dettagli Annuncio Segnalato
                  </h4>
                  <div className="space-y-2 text-sm">
                    <div>
                      <span className="text-gray-600">Titolo:</span>
                      <p className="font-medium text-gray-900">{(entityDetails as ClassifiedAdDetails).title}</p>
                    </div>
                    <div>
                      <span className="text-gray-600">Categoria:</span>
                      <p className="font-medium">{(entityDetails as ClassifiedAdDetails).category}</p>
                    </div>
                    {(entityDetails as ClassifiedAdDetails).price !== null && (
                      <div>
                        <span className="text-gray-600">Prezzo:</span>
                        <p className="font-medium text-green-600">€{(entityDetails as ClassifiedAdDetails).price}</p>
                      </div>
                    )}
                    <div>
                      <span className="text-gray-600">Descrizione:</span>
                      <p className="font-medium mt-1 text-gray-700">{(entityDetails as ClassifiedAdDetails).description}</p>
                    </div>
                  </div>
                </div>
              )}

              {!loadingDetails && entityDetails && selectedReport.reported_entity_type === 'review' && (
                <div className="bg-purple-50 rounded-lg p-4 border border-purple-200">
                  <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                    <MessageSquare className="w-5 h-5 text-purple-600" />
                    Dettagli Recensione Segnalata
                  </h4>
                  <div className="space-y-2 text-sm">
                    <div>
                      <span className="text-gray-600">Attività:</span>
                      <p className="font-medium text-gray-900">
                        {(entityDetails as ReviewDetails).business_location?.name ||
                         (entityDetails as ReviewDetails).unclaimed_business_location?.name ||
                         'Non specificato'}
                      </p>
                    </div>
                    <div>
                      <span className="text-gray-600">Valutazione:</span>
                      <p className="font-medium text-yellow-600">
                        {'⭐'.repeat((entityDetails as ReviewDetails).overall_rating)} ({(entityDetails as ReviewDetails).overall_rating}/5)
                      </p>
                    </div>
                    <div>
                      <span className="text-gray-600">Titolo:</span>
                      <p className="font-medium text-gray-900">{(entityDetails as ReviewDetails).title}</p>
                    </div>
                    <div>
                      <span className="text-gray-600">Contenuto:</span>
                      <p className="font-medium mt-1 text-gray-700">{(entityDetails as ReviewDetails).content}</p>
                    </div>
                  </div>
                </div>
              )}

              {!loadingDetails && entityDetails && selectedReport.reported_entity_type === 'business' && (
                <div className="bg-green-50 rounded-lg p-4 border border-green-200">
                  <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                    <Briefcase className="w-5 h-5 text-green-600" />
                    Dettagli Attività Segnalata
                  </h4>
                  <div className="space-y-2 text-sm">
                    <div>
                      <span className="text-gray-600">Nome:</span>
                      <p className="font-medium text-gray-900">{(entityDetails as BusinessDetails).name}</p>
                    </div>
                    {(entityDetails as BusinessDetails).category && (
                      <div>
                        <span className="text-gray-600">Categoria:</span>
                        <p className="font-medium">{(entityDetails as BusinessDetails).category}</p>
                      </div>
                    )}
                    {(entityDetails as BusinessDetails).address && (
                      <div>
                        <span className="text-gray-600">Indirizzo:</span>
                        <p className="font-medium">{(entityDetails as BusinessDetails).address}, {(entityDetails as BusinessDetails).city}</p>
                      </div>
                    )}
                    {(entityDetails as BusinessDetails).phone && (
                      <div>
                        <span className="text-gray-600">Telefono:</span>
                        <p className="font-medium">{(entityDetails as BusinessDetails).phone}</p>
                      </div>
                    )}
                    {(entityDetails as BusinessDetails).email && (
                      <div>
                        <span className="text-gray-600">Email:</span>
                        <p className="font-medium">{(entityDetails as BusinessDetails).email}</p>
                      </div>
                    )}
                    {(entityDetails as BusinessDetails).website && (
                      <div>
                        <span className="text-gray-600">Sito web:</span>
                        <p className="font-medium">
                          <a href={(entityDetails as BusinessDetails).website!} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                            {(entityDetails as BusinessDetails).website}
                          </a>
                        </p>
                      </div>
                    )}
                    {(entityDetails as BusinessDetails).description && (
                      <div>
                        <span className="text-gray-600">Descrizione:</span>
                        <p className="font-medium mt-1 text-gray-700">{(entityDetails as BusinessDetails).description}</p>
                      </div>
                    )}
                  </div>
                </div>
              )}

              {!loadingDetails && entityDetails && selectedReport.reported_entity_type === 'job_posting' && (
                <div className="bg-orange-50 rounded-lg p-4 border border-orange-200">
                  <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                    <Briefcase className="w-5 h-5 text-orange-600" />
                    Dettagli Offerta di Lavoro Segnalata
                  </h4>
                  <div className="space-y-2 text-sm">
                    <div>
                      <span className="text-gray-600">Titolo:</span>
                      <p className="font-medium text-gray-900">{(entityDetails as JobPostingDetails).title}</p>
                    </div>
                    {(entityDetails as JobPostingDetails).company_name && (
                      <div>
                        <span className="text-gray-600">Azienda:</span>
                        <p className="font-medium">{(entityDetails as JobPostingDetails).company_name}</p>
                      </div>
                    )}
                    {(entityDetails as JobPostingDetails).location && (
                      <div>
                        <span className="text-gray-600">Località:</span>
                        <p className="font-medium">{(entityDetails as JobPostingDetails).location}</p>
                      </div>
                    )}
                    {(entityDetails as JobPostingDetails).position_type && (
                      <div>
                        <span className="text-gray-600">Tipo posizione:</span>
                        <p className="font-medium">{(entityDetails as JobPostingDetails).position_type}</p>
                      </div>
                    )}
                    {(entityDetails as JobPostingDetails).experience_level && (
                      <div>
                        <span className="text-gray-600">Esperienza richiesta:</span>
                        <p className="font-medium">{(entityDetails as JobPostingDetails).experience_level}</p>
                      </div>
                    )}
                    <div>
                      <span className="text-gray-600">Descrizione:</span>
                      <p className="font-medium mt-1 text-gray-700">{(entityDetails as JobPostingDetails).description}</p>
                    </div>
                  </div>
                </div>
              )}

              {!loadingDetails && !entityDetails && (
                <div className="bg-yellow-50 rounded-lg p-4 border border-yellow-200 text-center">
                  <AlertTriangle className="w-12 h-12 text-yellow-600 mx-auto mb-2" />
                  <p className="text-gray-700">Il contenuto segnalato potrebbe essere stato eliminato</p>
                </div>
              )}
            </div>

            <div className="sticky bottom-0 bg-gray-50 px-6 py-4 flex gap-3 border-t border-gray-200">
              {selectedReport.status === 'pending' && (
                <>
                  <button
                    onClick={() => handleResolveReport(selectedReport.id)}
                    className="flex-1 px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors font-medium flex items-center justify-center gap-2"
                  >
                    <CheckCircle className="w-5 h-5" />
                    Risolvi Segnalazione
                  </button>
                  <button
                    onClick={() => handleDismissReport(selectedReport.id)}
                    className="flex-1 px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium flex items-center justify-center gap-2"
                  >
                    <XCircle className="w-5 h-5" />
                    Respingi Segnalazione
                  </button>
                </>
              )}
              <button
                onClick={() => setSelectedReport(null)}
                className="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors font-medium"
              >
                Chiudi
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
