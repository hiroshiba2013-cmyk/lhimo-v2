import { useState, useEffect } from 'react';
import { Heart, Upload, FileText, Download, Euro, Users, TrendingUp, Calendar, Plus, FileEdit as Edit2, Trash2, X, Building, Globe, Mail, Phone, MapPin } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

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
  uploaded_by: string;
}

interface CharityOrganization {
  id: string;
  name: string;
  description: string;
  category: string;
  website: string | null;
  logo_url: string | null;
  contact_email: string | null;
  contact_phone: string | null;
  address: string | null;
  is_active: boolean;
  total_received: number;
  created_at: string;
}

interface SubscriptionStats {
  totalActive: number;
  customerMonthly: number;
  customerYearly: number;
  businessMonthly: number;
  businessYearly: number;
  trialUsers: number;
}

interface SolidaritySectionProps {
  onReload: () => void;
}

export function SolidaritySection({ onReload }: SolidaritySectionProps) {
  const { showToast } = useToast();
  const [documents, setDocuments] = useState<SolidarityDocument[]>([]);
  const [organizations, setOrganizations] = useState<CharityOrganization[]>([]);
  const [totalRevenue, setTotalRevenue] = useState<number>(0);
  const [subscriptionStats, setSubscriptionStats] = useState<SubscriptionStats>({
    totalActive: 0,
    customerMonthly: 0,
    customerYearly: 0,
    businessMonthly: 0,
    businessYearly: 0,
    trialUsers: 0,
  });
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'stats' | 'documents' | 'organizations'>('stats');

  // Document upload form
  const [showDocumentForm, setShowDocumentForm] = useState(false);
  const [uploadingDocument, setUploadingDocument] = useState(false);
  const [documentForm, setDocumentForm] = useState({
    document_type: 'revenue' as 'revenue' | 'donation',
    title: '',
    description: '',
    year: new Date().getFullYear(),
    amount: '',
    recipient: '',
    file: null as File | null,
  });

  // Organization form
  const [showOrgForm, setShowOrgForm] = useState(false);
  const [editingOrg, setEditingOrg] = useState<CharityOrganization | null>(null);
  const [orgForm, setOrgForm] = useState({
    name: '',
    description: '',
    category: 'no-profit',
    website: '',
    contact_email: '',
    contact_phone: '',
    address: '',
    is_active: true,
  });

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    setLoading(true);
    await Promise.all([
      loadDocuments(),
      loadOrganizations(),
      loadRevenue(),
      loadSubscriptionStats(),
    ]);
    setLoading(false);
  };

  const loadRevenue = async () => {
    try {
      const { data, error } = await supabase.rpc('get_total_revenue');
      if (error) throw error;
      setTotalRevenue(parseFloat(data || 0));
    } catch (error) {
      console.error('Error loading revenue:', error);
    }
  };

  const loadSubscriptionStats = async () => {
    try {
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
    }
  };

  const loadDocuments = async () => {
    try {
      const { data, error } = await supabase
        .from('solidarity_documents')
        .select('*')
        .order('year', { ascending: false })
        .order('created_at', { ascending: false });

      if (error) throw error;
      setDocuments(data || []);
    } catch (error) {
      console.error('Error loading documents:', error);
    }
  };

  const loadOrganizations = async () => {
    try {
      const { data, error } = await supabase
        .from('charity_organizations')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setOrganizations(data || []);
    } catch (error) {
      console.error('Error loading organizations:', error);
    }
  };

  const handleDocumentUpload = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!documentForm.file) {
      showToast('Seleziona un file', 'info');
      return;
    }

    setUploadingDocument(true);
    try {
      const fileExt = documentForm.file.name.split('.').pop();
      const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
      const filePath = `solidarity/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('solidarity_documents')
        .upload(filePath, documentForm.file);

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('solidarity_documents')
        .getPublicUrl(filePath);

      const { data: userData } = await supabase.auth.getUser();

      const { error: insertError } = await supabase
        .from('solidarity_documents')
        .insert({
          document_type: documentForm.document_type,
          title: documentForm.title,
          description: documentForm.description || null,
          file_url: publicUrl,
          year: documentForm.year,
          amount: documentForm.amount ? parseFloat(documentForm.amount) : null,
          recipient: documentForm.recipient || null,
          uploaded_by: userData.user?.id,
        });

      if (insertError) throw insertError;

      showToast('Documento caricato con successo!', 'success');
      setShowDocumentForm(false);
      setDocumentForm({
        document_type: 'revenue',
        title: '',
        description: '',
        year: new Date().getFullYear(),
        amount: '',
        recipient: '',
        file: null,
      });
      loadDocuments();
      onReload();
    } catch (error: any) {
      console.error('Error uploading document:', error);
      showToast(`Errore: ${error.message}`, 'error');
    } finally {
      setUploadingDocument(false);
    }
  };

  const deleteDocument = async (docId: string) => {
    if (!confirm('Eliminare questo documento?')) return;

    try {
      const { error } = await supabase
        .from('solidarity_documents')
        .delete()
        .eq('id', docId);

      if (error) throw error;

      showToast('Documento eliminato', 'success');
      loadDocuments();
      onReload();
    } catch (error: any) {
      console.error('Error deleting document:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleOrgSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      if (editingOrg) {
        const { error } = await supabase
          .from('charity_organizations')
          .update(orgForm)
          .eq('id', editingOrg.id);

        if (error) throw error;
        showToast('Organizzazione aggiornata!', 'info');
      } else {
        const { error } = await supabase
          .from('charity_organizations')
          .insert(orgForm);

        if (error) throw error;
        showToast('Organizzazione aggiunta!', 'info');
      }

      setShowOrgForm(false);
      setEditingOrg(null);
      setOrgForm({
        name: '',
        description: '',
        category: 'no-profit',
        website: '',
        contact_email: '',
        contact_phone: '',
        address: '',
        is_active: true,
      });
      loadOrganizations();
      onReload();
    } catch (error: any) {
      console.error('Error saving organization:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const deleteOrganization = async (orgId: string) => {
    if (!confirm('Eliminare questa organizzazione?')) return;

    try {
      const { error } = await supabase
        .from('charity_organizations')
        .delete()
        .eq('id', orgId);

      if (error) throw error;

      showToast('Organizzazione eliminata', 'info');
      loadOrganizations();
      onReload();
    } catch (error: any) {
      console.error('Error deleting organization:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const editOrganization = (org: CharityOrganization) => {
    setEditingOrg(org);
    setOrgForm({
      name: org.name,
      description: org.description,
      category: org.category,
      website: org.website || '',
      contact_email: org.contact_email || '',
      contact_phone: org.contact_phone || '',
      address: org.address || '',
      is_active: org.is_active,
    });
    setShowOrgForm(true);
  };

  const totalDonations = documents
    .filter(d => d.document_type === 'donation')
    .reduce((sum, doc) => sum + (doc.amount || 0), 0);

  if (loading) {
    return (
      <div className="text-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-pink-600 mx-auto"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Hero Banner */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6 mb-6">
        {/* Dot overlay */}
        <div
          className="absolute inset-0 opacity-5"
          style={{
            backgroundImage: 'radial-gradient(circle, #ffffff 1px, transparent 1px)',
            backgroundSize: '20px 20px',
          }}
        />
        <div className="relative flex items-start justify-between gap-4">
          <div>
            <p className="text-xs font-semibold uppercase tracking-widest text-gray-400 mb-1">
              Trasparenza
            </p>
            <h2 className="text-2xl font-bold text-white mb-3">Solidarietà</h2>
            {/* Key metric chips */}
            <div className="flex flex-wrap gap-2">
              <span className="flex items-center gap-1.5 bg-white/10 border border-white/20 rounded-xl px-3 py-1 text-sm text-white font-medium">
                <Euro className="w-3.5 h-3.5" />
                €{totalRevenue.toLocaleString('it-IT', { minimumFractionDigits: 2 })} fatturato
              </span>
              <span className="flex items-center gap-1.5 bg-white/10 border border-white/20 rounded-xl px-3 py-1 text-sm text-white font-medium">
                <Users className="w-3.5 h-3.5" />
                {subscriptionStats.totalActive} abbonamenti attivi
              </span>
            </div>
          </div>
          <div className="flex flex-col gap-2 shrink-0">
            <button
              onClick={() => setShowDocumentForm(true)}
              className="flex items-center gap-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl px-4 py-2 transition-colors font-medium text-sm"
            >
              <Plus className="w-4 h-4" />
              Aggiungi documento
            </button>
            <button
              onClick={() => {
                setEditingOrg(null);
                setShowOrgForm(true);
              }}
              className="flex items-center gap-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl px-4 py-2 transition-colors font-medium text-sm"
            >
              <Plus className="w-4 h-4" />
              Aggiungi organizzazione
            </button>
          </div>
        </div>
      </div>

      {/* Tab switcher */}
      <div className="flex gap-2">
        <button
          onClick={() => setActiveTab('stats')}
          className={`flex items-center gap-2 rounded-xl px-4 py-2 text-sm font-semibold transition-colors ${
            activeTab === 'stats'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:bg-gray-50'
          }`}
        >
          <TrendingUp className="w-4 h-4" />
          Stats
        </button>
        <button
          onClick={() => setActiveTab('documents')}
          className={`flex items-center gap-2 rounded-xl px-4 py-2 text-sm font-semibold transition-colors ${
            activeTab === 'documents'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:bg-gray-50'
          }`}
        >
          <FileText className="w-4 h-4" />
          Documenti ({documents.length})
        </button>
        <button
          onClick={() => setActiveTab('organizations')}
          className={`flex items-center gap-2 rounded-xl px-4 py-2 text-sm font-semibold transition-colors ${
            activeTab === 'organizations'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:bg-gray-50'
          }`}
        >
          <Building className="w-4 h-4" />
          Organizzazioni ({organizations.length})
        </button>
      </div>

      <div>
        {/* Stats Tab */}
        {activeTab === 'stats' && (
          <div className="space-y-6">
            <h3 className="text-xl font-bold text-gray-900">Contatori Pubblici in Tempo Reale</h3>

            {/* Main Revenue Counters */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
                <div className="flex items-center justify-center mb-4">
                  <div className="bg-blue-500 p-4 rounded-full">
                    <Euro className="w-8 h-8 text-white" />
                  </div>
                </div>
                <h4 className="text-lg font-bold text-gray-900 mb-2 text-center">Fatturato Totale</h4>
                <div className="text-4xl font-bold text-blue-600 text-center">
                  €{totalRevenue.toLocaleString('it-IT', { minimumFractionDigits: 2 })}
                </div>
                <p className="text-sm text-gray-600 text-center mt-2">Da tutti gli abbonamenti attivi</p>
              </div>

              <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
                <div className="flex items-center justify-center mb-4">
                  <div className="bg-green-500 p-4 rounded-full">
                    <Heart className="w-8 h-8 text-white" />
                  </div>
                </div>
                <h4 className="text-lg font-bold text-gray-900 mb-2 text-center">Solidarietà (10%)</h4>
                <div className="text-4xl font-bold text-green-600 text-center">
                  €{(totalRevenue * 0.1).toLocaleString('it-IT', { minimumFractionDigits: 2 })}
                </div>
                <p className="text-sm text-gray-600 text-center mt-2">Destinato alla beneficenza</p>
              </div>
            </div>

            {/* Subscription Stats */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
              <h4 className="text-lg font-bold text-gray-900 mb-4 text-center">Abbonamenti Attivi</h4>
              <div className="text-5xl font-bold text-purple-600 text-center mb-6">
                {subscriptionStats.totalActive}
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div className="bg-gray-50 rounded-lg p-4 text-center">
                  <div className="text-2xl font-bold text-blue-600">{subscriptionStats.customerMonthly}</div>
                  <div className="text-xs text-gray-600 mt-1">Clienti Mensili</div>
                </div>
                <div className="bg-gray-50 rounded-lg p-4 text-center">
                  <div className="text-2xl font-bold text-cyan-600">{subscriptionStats.customerYearly}</div>
                  <div className="text-xs text-gray-600 mt-1">Clienti Annuali</div>
                </div>
                <div className="bg-gray-50 rounded-lg p-4 text-center">
                  <div className="text-2xl font-bold text-orange-600">{subscriptionStats.businessMonthly}</div>
                  <div className="text-xs text-gray-600 mt-1">Aziende Mensili</div>
                </div>
                <div className="bg-gray-50 rounded-lg p-4 text-center">
                  <div className="text-2xl font-bold text-amber-600">{subscriptionStats.businessYearly}</div>
                  <div className="text-xs text-gray-600 mt-1">Aziende Annuali</div>
                </div>
              </div>

              {subscriptionStats.trialUsers > 0 && (
                <div className="mt-4 bg-purple-50 rounded-lg p-3 text-center border border-purple-100">
                  <p className="text-sm font-semibold text-purple-900">
                    + {subscriptionStats.trialUsers} utenti in prova gratuita
                  </p>
                </div>
              )}
            </div>

            {/* Donations Stats */}
            {totalDonations > 0 && (
              <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
                <h4 className="text-lg font-bold text-gray-900 mb-2 text-center">Donazioni Totali Effettuate</h4>
                <div className="text-4xl font-bold text-rose-600 text-center">
                  €{totalDonations.toLocaleString('it-IT', { minimumFractionDigits: 2 })}
                </div>
                <p className="text-sm text-gray-600 text-center mt-2">
                  {documents.filter(d => d.document_type === 'donation').length} donazioni documentate
                </p>
              </div>
            )}

            <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
              <p className="text-sm text-gray-700 text-center">
                <span className="font-semibold">Nota:</span> Questi contatori sono visibili pubblicamente nella pagina Solidarietà
                e si aggiornano automaticamente in tempo reale
              </p>
            </div>
          </div>
        )}

        {/* Documents Tab */}
        {activeTab === 'documents' && (
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="text-xl font-bold text-gray-900">Documenti di Trasparenza</h3>
            </div>

            {documents.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-12 text-center">
                <FileText className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">Nessun documento caricato</p>
              </div>
            ) : (
              <div className="space-y-3">
                {documents.map((doc) => (
                  <div key={doc.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-2">
                          <span className={`px-3 py-1 rounded-full text-sm font-bold ${
                            doc.document_type === 'revenue'
                              ? 'bg-blue-100 text-blue-700'
                              : 'bg-green-100 text-green-700'
                          }`}>
                            {doc.document_type === 'revenue' ? 'Fatturato' : 'Donazione'}
                          </span>
                          <span className="text-sm text-gray-600 flex items-center gap-1">
                            <Calendar className="w-4 h-4" />
                            {doc.year}
                          </span>
                        </div>
                        <h4 className="font-bold text-gray-900 mb-1">{doc.title}</h4>
                        {doc.description && (
                          <p className="text-sm text-gray-600 mb-2">{doc.description}</p>
                        )}
                        <div className="flex flex-wrap gap-3 text-sm text-gray-600">
                          {doc.amount && (
                            <span className="flex items-center gap-1">
                              <Euro className="w-4 h-4" />
                              €{doc.amount.toLocaleString('it-IT')}
                            </span>
                          )}
                          {doc.recipient && (
                            <span>Destinatario: {doc.recipient}</span>
                          )}
                        </div>
                      </div>
                      <div className="flex items-center gap-2 ml-4">
                        <a
                          href={doc.file_url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                        >
                          <Download className="w-5 h-5" />
                        </a>
                        <button
                          onClick={() => deleteDocument(doc.id)}
                          className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Organizations Tab */}
        {activeTab === 'organizations' && (
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="text-xl font-bold text-gray-900">Organizzazioni Benefiche</h3>
            </div>

            {organizations.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-12 text-center">
                <Building className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">Nessuna organizzazione aggiunta</p>
              </div>
            ) : (
              <div className="grid md:grid-cols-2 gap-4">
                {organizations.map((org) => (
                  <div key={org.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow">
                    <div className="flex items-start justify-between mb-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-2">
                          <h4 className="font-bold text-lg text-gray-900">{org.name}</h4>
                          {org.is_active ? (
                            <span className="px-2 py-1 bg-green-100 text-green-700 text-xs font-semibold rounded-full">
                              Attiva
                            </span>
                          ) : (
                            <span className="px-2 py-1 bg-gray-100 text-gray-600 text-xs font-semibold rounded-full">
                              Inattiva
                            </span>
                          )}
                        </div>
                        <span className="text-sm text-blue-600 font-medium">{org.category}</span>
                      </div>
                      <div className="flex items-center gap-1">
                        <button
                          onClick={() => editOrganization(org)}
                          className="p-2 text-blue-600 hover:bg-blue-100 rounded-lg transition-colors"
                        >
                          <Edit2 className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => deleteOrganization(org.id)}
                          className="p-2 text-red-600 hover:bg-red-100 rounded-lg transition-colors"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </div>

                    <p className="text-sm text-gray-700 mb-3">{org.description}</p>

                    <div className="space-y-1 text-sm text-gray-600">
                      {org.website && (
                        <div className="flex items-center gap-2">
                          <Globe className="w-4 h-4" />
                          <a href={org.website} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                            {org.website}
                          </a>
                        </div>
                      )}
                      {org.contact_email && (
                        <div className="flex items-center gap-2">
                          <Mail className="w-4 h-4" />
                          <span>{org.contact_email}</span>
                        </div>
                      )}
                      {org.contact_phone && (
                        <div className="flex items-center gap-2">
                          <Phone className="w-4 h-4" />
                          <span>{org.contact_phone}</span>
                        </div>
                      )}
                      {org.address && (
                        <div className="flex items-center gap-2">
                          <MapPin className="w-4 h-4" />
                          <span>{org.address}</span>
                        </div>
                      )}
                    </div>

                    {org.total_received > 0 && (
                      <div className="mt-3 pt-3 border-t border-gray-100">
                        <div className="flex items-center gap-2 text-green-600 font-semibold">
                          <Euro className="w-4 h-4" />
                          <span>Ricevuto: €{org.total_received.toLocaleString('it-IT')}</span>
                        </div>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>

      {/* Document Upload Modal */}
      {showDocumentForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-gray-800 to-gray-900 px-6 py-4 flex items-center justify-between rounded-t-xl">
              <h3 className="text-xl font-bold text-white">Carica Documento</h3>
              <button
                onClick={() => setShowDocumentForm(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              >
                <X className="w-5 h-5 text-white" />
              </button>
            </div>

            <form onSubmit={handleDocumentUpload} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Tipo Documento *
                </label>
                <select
                  value={documentForm.document_type}
                  onChange={(e) => setDocumentForm({ ...documentForm, document_type: e.target.value as 'revenue' | 'donation' })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  required
                >
                  <option value="revenue">Fatturato</option>
                  <option value="donation">Donazione</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Titolo *
                </label>
                <input
                  type="text"
                  value={documentForm.title}
                  onChange={(e) => setDocumentForm({ ...documentForm, title: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  placeholder="Es: Bilancio 2024"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Descrizione
                </label>
                <textarea
                  value={documentForm.description}
                  onChange={(e) => setDocumentForm({ ...documentForm, description: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  rows={3}
                  placeholder="Descrizione opzionale..."
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Anno *
                  </label>
                  <input
                    type="number"
                    value={documentForm.year}
                    onChange={(e) => setDocumentForm({ ...documentForm, year: parseInt(e.target.value) })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    min="2020"
                    max="2100"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Importo (€)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={documentForm.amount}
                    onChange={(e) => setDocumentForm({ ...documentForm, amount: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    placeholder="0.00"
                  />
                </div>
              </div>

              {documentForm.document_type === 'donation' && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Destinatario
                  </label>
                  <input
                    type="text"
                    value={documentForm.recipient}
                    onChange={(e) => setDocumentForm({ ...documentForm, recipient: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    placeholder="Nome organizzazione destinataria"
                  />
                </div>
              )}

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  File Documento (PDF) *
                </label>
                <input
                  type="file"
                  accept=".pdf"
                  onChange={(e) => setDocumentForm({ ...documentForm, file: e.target.files?.[0] || null })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>

              <div className="flex gap-3 pt-4">
                <button
                  type="submit"
                  disabled={uploadingDocument}
                  className="flex-1 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 font-medium disabled:opacity-50"
                >
                  {uploadingDocument ? 'Caricamento...' : 'Carica Documento'}
                </button>
                <button
                  type="button"
                  onClick={() => setShowDocumentForm(false)}
                  className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 font-medium"
                >
                  Annulla
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Organization Form Modal */}
      {showOrgForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-gray-800 to-gray-900 px-6 py-4 flex items-center justify-between rounded-t-xl">
              <h3 className="text-xl font-bold text-white">
                {editingOrg ? 'Modifica Organizzazione' : 'Aggiungi Organizzazione'}
              </h3>
              <button
                onClick={() => {
                  setShowOrgForm(false);
                  setEditingOrg(null);
                }}
                className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              >
                <X className="w-5 h-5 text-white" />
              </button>
            </div>

            <form onSubmit={handleOrgSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Nome Organizzazione *
                </label>
                <input
                  type="text"
                  value={orgForm.name}
                  onChange={(e) => setOrgForm({ ...orgForm, name: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                  placeholder="Es: Croce Rossa Italiana"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Descrizione *
                </label>
                <textarea
                  value={orgForm.description}
                  onChange={(e) => setOrgForm({ ...orgForm, description: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                  rows={4}
                  placeholder="Descrizione dell'organizzazione e delle sue attività..."
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Categoria *
                </label>
                <select
                  value={orgForm.category}
                  onChange={(e) => setOrgForm({ ...orgForm, category: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                  required
                >
                  <option value="no-profit">No Profit</option>
                  <option value="beneficenza">Beneficenza</option>
                  <option value="sociale">Sociale</option>
                  <option value="ambiente">Ambiente</option>
                  <option value="salute">Salute</option>
                  <option value="educazione">Educazione</option>
                  <option value="altro">Altro</option>
                </select>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Sito Web
                  </label>
                  <input
                    type="url"
                    value={orgForm.website}
                    onChange={(e) => setOrgForm({ ...orgForm, website: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                    placeholder="https://..."
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Email di Contatto
                  </label>
                  <input
                    type="email"
                    value={orgForm.contact_email}
                    onChange={(e) => setOrgForm({ ...orgForm, contact_email: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                    placeholder="info@organizzazione.it"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Telefono
                  </label>
                  <input
                    type="tel"
                    value={orgForm.contact_phone}
                    onChange={(e) => setOrgForm({ ...orgForm, contact_phone: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                    placeholder="+39 ..."
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Indirizzo
                  </label>
                  <input
                    type="text"
                    value={orgForm.address}
                    onChange={(e) => setOrgForm({ ...orgForm, address: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500"
                    placeholder="Via, Città"
                  />
                </div>
              </div>

              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="is_active"
                  checked={orgForm.is_active}
                  onChange={(e) => setOrgForm({ ...orgForm, is_active: e.target.checked })}
                  className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                />
                <label htmlFor="is_active" className="text-sm font-medium text-gray-700">
                  Organizzazione attiva (visibile al pubblico)
                </label>
              </div>

              <div className="flex gap-3 pt-4">
                <button
                  type="submit"
                  className="flex-1 bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 font-medium"
                >
                  {editingOrg ? 'Aggiorna' : 'Aggiungi'} Organizzazione
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setShowOrgForm(false);
                    setEditingOrg(null);
                  }}
                  className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 font-medium"
                >
                  Annulla
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
