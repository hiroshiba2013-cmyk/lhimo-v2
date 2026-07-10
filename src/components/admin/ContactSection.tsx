import { useState, useEffect } from 'react';
import { Mail, Phone, MapPin, Facebook, Instagram, Twitter, MessageCircle, Clock, Save, FileEdit as Edit } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface ContactSettings {
  email: string;
  phone: string;
  address: {
    street: string;
    city: string;
    cap: string;
    country: string;
  };
  facebook: string;
  instagram: string;
  twitter: string;
  whatsapp: string;
  supportHours: string;
}

interface ContactSectionProps {
  adminId: string;
}

export function ContactSection({ adminId }: ContactSectionProps) {
  const { showToast } = useToast();
  const [settings, setSettings] = useState<ContactSettings>({
    email: '',
    phone: '',
    address: { street: '', city: '', cap: '', country: 'Italia' },
    facebook: '',
    instagram: '',
    twitter: '',
    whatsapp: '',
    supportHours: '',
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editing, setEditing] = useState(false);

  useEffect(() => {
    loadSettings();
  }, []);

  const loadSettings = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('platform_settings')
        .select('*')
        .eq('category', 'contact');

      if (error) throw error;

      const settingsObj: any = {
        email: '',
        phone: '',
        address: { street: '', city: '', cap: '', country: 'Italia' },
        facebook: '',
        instagram: '',
        twitter: '',
        whatsapp: '',
        supportHours: '',
      };

      data?.forEach((setting) => {
        switch (setting.setting_key) {
          case 'contact_email':
            settingsObj.email = setting.setting_value.value || '';
            break;
          case 'contact_phone':
            settingsObj.phone = setting.setting_value.value || '';
            break;
          case 'contact_address':
            settingsObj.address = setting.setting_value;
            break;
          case 'contact_social_facebook':
            settingsObj.facebook = setting.setting_value.value || '';
            break;
          case 'contact_social_instagram':
            settingsObj.instagram = setting.setting_value.value || '';
            break;
          case 'contact_social_twitter':
            settingsObj.twitter = setting.setting_value.value || '';
            break;
          case 'contact_whatsapp':
            settingsObj.whatsapp = setting.setting_value.value || '';
            break;
          case 'contact_support_hours':
            settingsObj.supportHours = setting.setting_value.value || '';
            break;
        }
      });

      setSettings(settingsObj);
    } catch (error: any) {
      console.error('Error loading settings:', error);
      showToast('Errore nel caricamento delle impostazioni', 'error');
    } finally {
      setLoading(false);
    }
  };

  const saveSettings = async () => {
    try {
      setSaving(true);

      const updates = [
        { key: 'contact_email', value: { value: settings.email } },
        { key: 'contact_phone', value: { value: settings.phone } },
        { key: 'contact_address', value: settings.address },
        { key: 'contact_social_facebook', value: { value: settings.facebook } },
        { key: 'contact_social_instagram', value: { value: settings.instagram } },
        { key: 'contact_social_twitter', value: { value: settings.twitter } },
        { key: 'contact_whatsapp', value: { value: settings.whatsapp } },
        { key: 'contact_support_hours', value: { value: settings.supportHours } },
      ];

      for (const update of updates) {
        const { error } = await supabase
          .from('platform_settings')
          .update({
            setting_value: update.value,
            updated_by: adminId,
            updated_at: new Date().toISOString(),
          })
          .eq('setting_key', update.key);

        if (error) throw error;
      }

      showToast('Impostazioni salvate con successo!', 'success');
      setEditing(false);
      loadSettings();
    } catch (error: any) {
      console.error('Error saving settings:', error);
      showToast(`Errore: ${error.message}`, 'error');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Hero Banner */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6 mb-6">
        {/* Dot overlay */}
        <div
          className="absolute inset-0 opacity-10"
          style={{
            backgroundImage: 'radial-gradient(circle, #ffffff 1px, transparent 1px)',
            backgroundSize: '24px 24px',
          }}
        />
        <div className="relative flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-1">
              Configurazione
            </p>
            <h2 className="text-2xl font-bold text-white">Contatti Piattaforma</h2>
          </div>
          <div>
            {!editing ? (
              <button
                onClick={() => setEditing(true)}
                className="flex items-center gap-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl px-4 py-2 transition-colors"
              >
                <Edit className="w-4 h-4" />
                Modifica
              </button>
            ) : (
              <div className="flex gap-2">
                <button
                  onClick={() => {
                    setEditing(false);
                    loadSettings();
                  }}
                  className="px-4 py-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl transition-colors"
                >
                  Annulla
                </button>
                <button
                  onClick={saveSettings}
                  disabled={saving}
                  className="flex items-center gap-2 bg-orange-500 hover:bg-orange-600 text-white rounded-xl px-4 py-2 font-semibold transition-colors disabled:opacity-60"
                >
                  <Save className="w-4 h-4" />
                  {saving ? 'Salvataggio...' : 'Salva'}
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Contact Info Section */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 mb-4">
        <p className="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-4 flex items-center gap-2">
          <Mail className="w-3.5 h-3.5" />
          Informazioni di contatto
        </p>

        <div className="space-y-4">
          {/* Email */}
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <Mail className="w-4 h-4" />
              Email di Contatto
            </label>
            <input
              type="email"
              value={settings.email}
              onChange={(e) => setSettings({ ...settings, email: e.target.value })}
              disabled={!editing}
              className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
            />
          </div>

          {/* Telefono */}
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <Phone className="w-4 h-4" />
              Telefono
            </label>
            <input
              type="tel"
              value={settings.phone}
              onChange={(e) => setSettings({ ...settings, phone: e.target.value })}
              disabled={!editing}
              className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
            />
          </div>

          {/* WhatsApp */}
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <MessageCircle className="w-4 h-4" />
              WhatsApp
            </label>
            <input
              type="tel"
              value={settings.whatsapp}
              onChange={(e) => setSettings({ ...settings, whatsapp: e.target.value })}
              disabled={!editing}
              className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
            />
          </div>

          {/* Indirizzo */}
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <MapPin className="w-4 h-4" />
              Indirizzo Fisico
            </label>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <input
                type="text"
                value={settings.address.street}
                onChange={(e) => setSettings({
                  ...settings,
                  address: { ...settings.address, street: e.target.value }
                })}
                disabled={!editing}
                placeholder="Via/Piazza"
                className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
              />
              <input
                type="text"
                value={settings.address.city}
                onChange={(e) => setSettings({
                  ...settings,
                  address: { ...settings.address, city: e.target.value }
                })}
                disabled={!editing}
                placeholder="Città"
                className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
              />
              <input
                type="text"
                value={settings.address.cap}
                onChange={(e) => setSettings({
                  ...settings,
                  address: { ...settings.address, cap: e.target.value }
                })}
                disabled={!editing}
                placeholder="CAP"
                className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
              />
              <input
                type="text"
                value={settings.address.country}
                onChange={(e) => setSettings({
                  ...settings,
                  address: { ...settings.address, country: e.target.value }
                })}
                disabled={!editing}
                placeholder="Paese"
                className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Socials Section */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 mb-4">
        <p className="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-4 flex items-center gap-2">
          <Facebook className="w-3.5 h-3.5" />
          Social Media
        </p>

        <div className="space-y-4">
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <Facebook className="w-4 h-4" />
              Facebook
            </label>
            <input
              type="url"
              value={settings.facebook}
              onChange={(e) => setSettings({ ...settings, facebook: e.target.value })}
              disabled={!editing}
              placeholder="https://facebook.com/..."
              className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <Instagram className="w-4 h-4" />
              Instagram
            </label>
            <input
              type="url"
              value={settings.instagram}
              onChange={(e) => setSettings({ ...settings, instagram: e.target.value })}
              disabled={!editing}
              placeholder="https://instagram.com/..."
              className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
              <Twitter className="w-4 h-4" />
              Twitter
            </label>
            <input
              type="url"
              value={settings.twitter}
              onChange={(e) => setSettings({ ...settings, twitter: e.target.value })}
              disabled={!editing}
              placeholder="https://twitter.com/..."
              className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
            />
          </div>
        </div>
      </div>

      {/* Hours Section */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 mb-4">
        <p className="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-4 flex items-center gap-2">
          <Clock className="w-3.5 h-3.5" />
          Orari
        </p>

        <div>
          <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 mb-2">
            <Clock className="w-4 h-4" />
            Orari Assistenza
          </label>
          <input
            type="text"
            value={settings.supportHours}
            onChange={(e) => setSettings({ ...settings, supportHours: e.target.value })}
            disabled={!editing}
            placeholder="Es: Lun-Ven 9:00-18:00"
            className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:ring-2 focus:ring-gray-900 focus:border-transparent disabled:bg-gray-100"
          />
        </div>
      </div>
    </div>
  );
}
