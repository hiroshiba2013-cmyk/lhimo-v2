import { useState, useRef, useCallback } from 'react';
import { Download, RefreshCw, CheckCircle, XCircle, Play, Square, Plus, Trash2, MapPin, ChevronDown, Layers } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';


const PROVINCES: { code: string; region: string; label: string }[] = [
  { code:"AQ", region:"Abruzzo", label:"AQ - L'Aquila" },
  { code:"CH", region:"Abruzzo", label:"CH - Chieti" },
  { code:"PE", region:"Abruzzo", label:"PE - Pescara" },
  { code:"TE", region:"Abruzzo", label:"TE - Teramo" },
  { code:"MT", region:"Basilicata", label:"MT - Matera" },
  { code:"PZ", region:"Basilicata", label:"PZ - Potenza" },
  { code:"CS", region:"Calabria", label:"CS - Cosenza" },
  { code:"CZ", region:"Calabria", label:"CZ - Catanzaro" },
  { code:"KR", region:"Calabria", label:"KR - Crotone" },
  { code:"RC", region:"Calabria", label:"RC - Reggio Calabria" },
  { code:"VV", region:"Calabria", label:"VV - Vibo Valentia" },
  { code:"AV", region:"Campania", label:"AV - Avellino" },
  { code:"BN", region:"Campania", label:"BN - Benevento" },
  { code:"CE", region:"Campania", label:"CE - Caserta" },
  { code:"NA", region:"Campania", label:"NA - Napoli" },
  { code:"SA", region:"Campania", label:"SA - Salerno" },
  { code:"BO", region:"Emilia-Romagna", label:"BO - Bologna" },
  { code:"FC", region:"Emilia-Romagna", label:"FC - Forlì-Cesena" },
  { code:"FE", region:"Emilia-Romagna", label:"FE - Ferrara" },
  { code:"MO", region:"Emilia-Romagna", label:"MO - Modena" },
  { code:"PC", region:"Emilia-Romagna", label:"PC - Piacenza" },
  { code:"PR", region:"Emilia-Romagna", label:"PR - Parma" },
  { code:"RA", region:"Emilia-Romagna", label:"RA - Ravenna" },
  { code:"RE", region:"Emilia-Romagna", label:"RE - Reggio Emilia" },
  { code:"RN", region:"Emilia-Romagna", label:"RN - Rimini" },
  { code:"GO", region:"Friuli-Venezia Giulia", label:"GO - Gorizia" },
  { code:"PN", region:"Friuli-Venezia Giulia", label:"PN - Pordenone" },
  { code:"TS", region:"Friuli-Venezia Giulia", label:"TS - Trieste" },
  { code:"UD", region:"Friuli-Venezia Giulia", label:"UD - Udine" },
  { code:"FR", region:"Lazio", label:"FR - Frosinone" },
  { code:"LT", region:"Lazio", label:"LT - Latina" },
  { code:"RI", region:"Lazio", label:"RI - Rieti" },
  { code:"RM", region:"Lazio", label:"RM - Roma" },
  { code:"VT", region:"Lazio", label:"VT - Viterbo" },
  { code:"GE", region:"Liguria", label:"GE - Genova" },
  { code:"IM", region:"Liguria", label:"IM - Imperia" },
  { code:"SP", region:"Liguria", label:"SP - La Spezia" },
  { code:"SV", region:"Liguria", label:"SV - Savona" },
  { code:"BG", region:"Lombardia", label:"BG - Bergamo" },
  { code:"BS", region:"Lombardia", label:"BS - Brescia" },
  { code:"CO", region:"Lombardia", label:"CO - Como" },
  { code:"CR", region:"Lombardia", label:"CR - Cremona" },
  { code:"LC", region:"Lombardia", label:"LC - Lecco" },
  { code:"LO", region:"Lombardia", label:"LO - Lodi" },
  { code:"MB", region:"Lombardia", label:"MB - Monza e Brianza" },
  { code:"MI", region:"Lombardia", label:"MI - Milano" },
  { code:"MN", region:"Lombardia", label:"MN - Mantova" },
  { code:"PV", region:"Lombardia", label:"PV - Pavia" },
  { code:"SO", region:"Lombardia", label:"SO - Sondrio" },
  { code:"VA", region:"Lombardia", label:"VA - Varese" },
  { code:"AN", region:"Marche", label:"AN - Ancona" },
  { code:"AP", region:"Marche", label:"AP - Ascoli Piceno" },
  { code:"FM", region:"Marche", label:"FM - Fermo" },
  { code:"MC", region:"Marche", label:"MC - Macerata" },
  { code:"PU", region:"Marche", label:"PU - Pesaro e Urbino" },
  { code:"CB", region:"Molise", label:"CB - Campobasso" },
  { code:"IS", region:"Molise", label:"IS - Isernia" },
  { code:"AL", region:"Piemonte", label:"AL - Alessandria" },
  { code:"AT", region:"Piemonte", label:"AT - Asti" },
  { code:"BI", region:"Piemonte", label:"BI - Biella" },
  { code:"CN", region:"Piemonte", label:"CN - Cuneo" },
  { code:"NO", region:"Piemonte", label:"NO - Novara" },
  { code:"TO", region:"Piemonte", label:"TO - Torino" },
  { code:"VB", region:"Piemonte", label:"VB - Verbano-Cusio-Ossola" },
  { code:"VC", region:"Piemonte", label:"VC - Vercelli" },
  { code:"BA", region:"Puglia", label:"BA - Bari" },
  { code:"BR", region:"Puglia", label:"BR - Brindisi" },
  { code:"BT", region:"Puglia", label:"BT - Barletta-Andria-Trani" },
  { code:"FG", region:"Puglia", label:"FG - Foggia" },
  { code:"LE", region:"Puglia", label:"LE - Lecce" },
  { code:"TA", region:"Puglia", label:"TA - Taranto" },
  { code:"CA", region:"Sardegna", label:"CA - Cagliari" },
  { code:"NU", region:"Sardegna", label:"NU - Nuoro" },
  { code:"OR", region:"Sardegna", label:"OR - Oristano" },
  { code:"OT", region:"Sardegna", label:"OT - Olbia-Tempio" },
  { code:"SS", region:"Sardegna", label:"SS - Sassari" },
  { code:"AG", region:"Sicilia", label:"AG - Agrigento" },
  { code:"CL", region:"Sicilia", label:"CL - Caltanissetta" },
  { code:"CT", region:"Sicilia", label:"CT - Catania" },
  { code:"EN", region:"Sicilia", label:"EN - Enna" },
  { code:"ME", region:"Sicilia", label:"ME - Messina" },
  { code:"PA", region:"Sicilia", label:"PA - Palermo" },
  { code:"RG", region:"Sicilia", label:"RG - Ragusa" },
  { code:"SR", region:"Sicilia", label:"SR - Siracusa" },
  { code:"TP", region:"Sicilia", label:"TP - Trapani" },
  { code:"AR", region:"Toscana", label:"AR - Arezzo" },
  { code:"FI", region:"Toscana", label:"FI - Firenze" },
  { code:"GR", region:"Toscana", label:"GR - Grosseto" },
  { code:"LI", region:"Toscana", label:"LI - Livorno" },
  { code:"LU", region:"Toscana", label:"LU - Lucca" },
  { code:"MS", region:"Toscana", label:"MS - Massa-Carrara" },
  { code:"PI", region:"Toscana", label:"PI - Pisa" },
  { code:"PO", region:"Toscana", label:"PO - Prato" },
  { code:"PT", region:"Toscana", label:"PT - Pistoia" },
  { code:"SI", region:"Toscana", label:"SI - Siena" },
  { code:"BZ", region:"Trentino-Alto Adige", label:"BZ - Bolzano" },
  { code:"TN", region:"Trentino-Alto Adige", label:"TN - Trento" },
  { code:"PG", region:"Umbria", label:"PG - Perugia" },
  { code:"TR", region:"Umbria", label:"TR - Terni" },
  { code:"AO", region:"Valle d'Aosta", label:"AO - Aosta" },
  { code:"BL", region:"Veneto", label:"BL - Belluno" },
  { code:"PD", region:"Veneto", label:"PD - Padova" },
  { code:"RO", region:"Veneto", label:"RO - Rovigo" },
  { code:"TV", region:"Veneto", label:"TV - Treviso" },
  { code:"VE", region:"Veneto", label:"VE - Venezia" },
  { code:"VI", region:"Veneto", label:"VI - Vicenza" },
  { code:"VR", region:"Veneto", label:"VR - Verona" },
];

const OSM_TAGS: { tag: string; label: string }[] = [
  { tag:"restaurant", label:"Ristoranti" },
  { tag:"fast_food", label:"Fast Food" },
  { tag:"cafe", label:"Bar e Caffè" },
  { tag:"bar", label:"Bar" },
  { tag:"pub", label:"Pub" },
  { tag:"pizza", label:"Pizzerie" },
  { tag:"ice_cream", label:"Gelaterie" },
  { tag:"bakery", label:"Panetterie" },
  { tag:"pastry", label:"Pasticcerie" },
  { tag:"supermarket", label:"Supermercati" },
  { tag:"convenience", label:"Alimentari" },
  { tag:"butcher", label:"Macellerie" },
  { tag:"fishmonger", label:"Pescherie" },
  { tag:"greengrocer", label:"Frutta e Verdura" },
  { tag:"deli", label:"Gastronomie" },
  { tag:"wine", label:"Enoteche" },
  { tag:"pharmacy", label:"Farmacie" },
  { tag:"doctors", label:"Medici" },
  { tag:"dentist", label:"Dentisti" },
  { tag:"hospital", label:"Ospedali" },
  { tag:"clinic", label:"Cliniche" },
  { tag:"veterinary", label:"Veterinari" },
  { tag:"optician", label:"Ottici" },
  { tag:"hairdresser", label:"Parrucchieri" },
  { tag:"beauty", label:"Centri Estetici" },
  { tag:"hotel", label:"Hotel" },
  { tag:"guest_house", label:"B&B" },
  { tag:"hostel", label:"Ostelli" },
  { tag:"camp_site", label:"Campeggi" },
  { tag:"bank", label:"Banche" },
  { tag:"atm", label:"Bancomat" },
  { tag:"insurance", label:"Assicurazioni" },
  { tag:"lawyer", label:"Avvocati" },
  { tag:"notary", label:"Notai" },
  { tag:"accountant", label:"Commercialisti" },
  { tag:"architect", label:"Architetti" },
  { tag:"estate_agent", label:"Agenzie Immobiliari" },
  { tag:"travel_agency", label:"Agenzie di Viaggio" },
  { tag:"school", label:"Scuole" },
  { tag:"kindergarten", label:"Asili" },
  { tag:"driving_school", label:"Autoscuole" },
  { tag:"clothes", label:"Abbigliamento" },
  { tag:"shoes", label:"Calzature" },
  { tag:"electronics", label:"Elettronica" },
  { tag:"mobile_phone", label:"Telefonia" },
  { tag:"furniture", label:"Arredamento" },
  { tag:"hardware", label:"Ferramenta" },
  { tag:"doityourself", label:"Fai da Te" },
  { tag:"books", label:"Librerie" },
  { tag:"florist", label:"Fioristi" },
  { tag:"jewelry", label:"Gioiellerie" },
  { tag:"toys", label:"Giocattoli" },
  { tag:"sports", label:"Negozi Sport" },
  { tag:"bicycle", label:"Biciclette" },
  { tag:"car_repair", label:"Autofficine" },
  { tag:"car_dealer", label:"Concessionarie" },
  { tag:"fuel", label:"Distributori" },
  { tag:"tyres", label:"Pneumatici" },
  { tag:"gym", label:"Palestre" },
  { tag:"laundry", label:"Lavanderie" },
  { tag:"post_office", label:"Uffici Postali" },
  { tag:"funeral_directors", label:"Onoranze Funebri" },
  { tag:"tobacco", label:"Tabaccherie" },
  { tag:"newsagent", label:"Edicole" },
  { tag:"carpenter", label:"Falegnami" },
  { tag:"plumber", label:"Idraulici" },
  { tag:"electrician", label:"Elettricisti" },
  { tag:"winery", label:"Cantine" },
];

interface ComuneEntry { city: string; province: string; region: string; }
interface StepResult {
  tag: string; label: string;
  status: 'pending' | 'fetching' | 'inserting' | 'done' | 'error';
  found?: number; imported?: number; skipped?: number; error?: string;
}

export function OsmImportSection() {
  const { showToast } = useToast();

  // Comuni list
  const [comuneInput, setComuneInput] = useState('');
  const [provinceInput, setProvinceInput] = useState('');
  const [comuni, setComuni] = useState<ComuneEntry[]>([]);

  // City dropdown state
  const [cityList, setCityList] = useState<string[]>([]);
  const [loadingCities, setLoadingCities] = useState(false);

  const loadCities = useCallback(async (provCode: string) => {
    if (!provCode) { setCityList([]); return; }
    setLoadingCities(true);
    const { data } = await supabase.rpc('get_comuni_by_provincia', { p_provincia: provCode });
    setCityList(data ? data.map((r: { comune: string }) => r.comune) : []);
    setLoadingCities(false);
  }, []);

  // Selected tags
  const [selectedTags, setSelectedTags] = useState<Set<string>>(new Set(OSM_TAGS.map(t => t.tag)));

  // Current run state
  const [currentComune, setCurrentComune] = useState<ComuneEntry | null>(null);
  const [steps, setSteps] = useState<StepResult[]>([]);
  const [comuneIndex, setComuneIndex] = useState(0);
  const [running, setRunning] = useState(false);
  const abortRef = useRef(false);

  const updateStep = (i: number, patch: Partial<StepResult>) =>
    setSteps(prev => prev.map((s, idx) => idx === i ? { ...s, ...patch } : s));

  const addComune = () => {
    const city = comuneInput.trim();
    const prov = PROVINCES.find(p => p.code === provinceInput);
    if (!city || !prov) return;
    if (comuni.some(c => c.city.toLowerCase() === city.toLowerCase() && c.province === prov.code)) return;
    setComuni(prev => [...prev, { city, province: prov.code, region: prov.region }]);
    setComuneInput('');
  };

  const onProvinceChange = (code: string) => {
    setProvinceInput(code);
    setComuneInput('');
    setCityList([]);
    if (code) loadCities(code);
  };

  const addAllComuniInProvince = () => {
    if (!provinceInput || cityList.length === 0) return;
    const prov = PROVINCES.find(p => p.code === provinceInput);
    if (!prov) return;
    setComuni(prev => {
      const existing = new Set(prev.map(c => c.city.toLowerCase()));
      const additions = cityList
        .filter(c => !existing.has(c.toLowerCase()))
        .map(c => ({ city: c, province: prov.code, region: prov.region }));
      return [...prev, ...additions];
    });
  };

  const removeComune = (i: number) => setComuni(prev => prev.filter((_, idx) => idx !== i));

  const runForComune = async (comune: ComuneEntry) => {
    const tagList = OSM_TAGS.filter(t => selectedTags.has(t.tag));
    const initial: StepResult[] = tagList.map(t => ({ tag: t.tag, label: t.label, status: 'pending' }));
    setSteps(initial);
    setCurrentComune(comune);

    // Fetch coordinates for this comune from DB (enables faster around-query)
    let lat: number | undefined;
    let lng: number | undefined;
    try {
      const { data: coordRow } = await supabase
        .from('comuni_italiani')
        .select('lat, lng')
        .eq('nome', comune.city)
        .eq('sigla_provincia', comune.province)
        .maybeSingle();
      if (coordRow) { lat = coordRow.lat; lng = coordRow.lng; }
    } catch { /* fall back to area-based query */ }

    for (let i = 0; i < tagList.length; i++) {
      if (abortRef.current) break;
      const { tag, label } = tagList[i];

      updateStep(i, { status: 'fetching' });
      try {
        const { data, error } = await supabase.rpc('import_osm_for_comune', {
          p_city: comune.city,
          p_province: comune.province,
          p_region: comune.region,
          p_osm_tag: tag,
          p_lat: lat ?? null,
          p_lng: lng ?? null,
        });
        if (error) throw new Error(error.message || 'Errore RPC');
        if (data?.error) throw new Error(data.error);
        updateStep(i, {
          status: 'done',
          found: data.found ?? 0,
          imported: data.imported ?? 0,
          skipped: data.skipped ?? 0,
        });
      } catch (e: any) {
        updateStep(i, { status: 'error', error: e.message });
        await new Promise(r => setTimeout(r, 500));
        continue;
      }

      if (i < tagList.length - 1 && !abortRef.current) {
        await new Promise(r => setTimeout(r, 600));
      }
    }
  };

  const startImport = async () => {
    if (comuni.length === 0) { showToast('Aggiungi almeno un comune', 'error'); return; }
    if (selectedTags.size === 0) { showToast('Seleziona almeno una categoria', 'error'); return; }

    abortRef.current = false;
    setRunning(true);
    setComuneIndex(0);
    setSteps([]);

    for (let ci = 0; ci < comuni.length; ci++) {
      if (abortRef.current) break;
      setComuneIndex(ci);
      await runForComune(comuni[ci]);
    }

    setRunning(false);
    if (!abortRef.current) showToast('Import completato per tutti i comuni', 'success');
  };

  const stopImport = () => { abortRef.current = true; setRunning(false); };

  const done = steps.filter(s => s.status === 'done');
  const errors = steps.filter(s => s.status === 'error');
  const totalImported = done.reduce((s, r) => s + (r.imported ?? 0), 0);
  const totalFound = done.reduce((s, r) => s + (r.found ?? 0), 0);
  const progress = steps.length > 0 ? (done.length + errors.length) / steps.length : 0;

  const byRegion = PROVINCES.reduce<Record<string, typeof PROVINCES>>((acc, p) => {
    if (!acc[p.region]) acc[p.region] = [];
    acc[p.region].push(p);
    return acc;
  }, {});

  return (
    <div className="space-y-6">

      {/* ── Comuni list ── */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
        <div className="flex items-center gap-3 mb-5">
          <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center">
            <MapPin className="w-5 h-5 text-emerald-600" />
          </div>
          <div>
            <h2 className="text-lg font-bold text-gray-900">Import da OpenStreetMap</h2>
            <p className="text-sm text-gray-500">Aggiungi i comuni da importare — la query va comune per comune, categoria per categoria</p>
          </div>
        </div>

        {/* Add comune row */}
        <div className="flex gap-2 mb-4">
          <div className="relative flex-1">
            <select
              value={comuneInput}
              onChange={e => setComuneInput(e.target.value)}
              disabled={running || !provinceInput || loadingCities}
              className="w-full appearance-none px-3 py-2.5 pr-9 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-white disabled:opacity-50 cursor-pointer"
            >
              <option value="" disabled>
                {loadingCities ? 'Caricamento...' : provinceInput ? 'Seleziona comune...' : 'Prima scegli la provincia'}
              </option>
              {cityList.map(c => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
            <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              {loadingCities
                ? <div className="w-4 h-4 border-2 border-emerald-400 border-t-transparent rounded-full animate-spin" />
                : cityList.length > 0 ? <ChevronDown className="w-4 h-4 text-gray-400" /> : null
              }
            </div>
          </div>
          <select
            value={provinceInput}
            onChange={e => onProvinceChange(e.target.value)}
            disabled={running}
            className="px-3 py-2.5 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-white disabled:opacity-50 min-w-[200px]"
          >
            <option value="">Provincia...</option>
            {Object.entries(byRegion).sort(([a], [b]) => a.localeCompare(b)).map(([reg, provs]) => (
              <optgroup key={reg} label={reg}>
                {provs.map(p => <option key={p.code} value={p.code}>{p.label}</option>)}
              </optgroup>
            ))}
          </select>
          <button
            onClick={addComune}
            disabled={running || !comuneInput.trim() || !provinceInput}
            className="flex items-center gap-1.5 px-4 py-2.5 bg-emerald-600 text-white rounded-lg text-sm font-semibold hover:bg-emerald-700 disabled:opacity-40 transition-colors"
          >
            <Plus className="w-4 h-4" />
            Aggiungi
          </button>
          <button
            onClick={addAllComuniInProvince}
            disabled={running || !provinceInput || cityList.length === 0}
            className="flex items-center gap-1.5 px-4 py-2.5 bg-blue-600 text-white rounded-lg text-sm font-semibold hover:bg-blue-700 disabled:opacity-40 transition-colors whitespace-nowrap"
          >
            <Layers className="w-4 h-4" />
            Tutti i comuni
          </button>
        </div>
        {provinceInput && !loadingCities && cityList.length > 0 && (
          <p className="-mt-2 mb-3 text-xs text-gray-400">{cityList.length} comuni disponibili</p>
        )}

        {/* Comuni chips */}
        {comuni.length > 0 && (
          <div className="flex flex-wrap gap-2 mb-5 p-3 bg-gray-50 rounded-xl">
            {comuni.map((c, i) => (
              <div
                key={i}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-medium border transition-colors ${
                  running && comuneIndex === i
                    ? 'bg-blue-100 border-blue-300 text-blue-800'
                    : running && comuneIndex > i
                    ? 'bg-green-100 border-green-300 text-green-700'
                    : 'bg-white border-gray-200 text-gray-700'
                }`}
              >
                {running && comuneIndex === i && <RefreshCw className="w-3 h-3 animate-spin" />}
                {running && comuneIndex > i && <CheckCircle className="w-3 h-3" />}
                <span>{c.city}</span>
                <span className="text-gray-400 text-xs">{c.province}</span>
                {!running && (
                  <button onClick={() => removeComune(i)} className="ml-1 text-gray-300 hover:text-red-400 transition-colors">
                    <Trash2 className="w-3 h-3" />
                  </button>
                )}
              </div>
            ))}
          </div>
        )}

        {/* Tags */}
        <div className="mb-5">
          <div className="flex items-center justify-between mb-2">
            <span className="text-xs font-semibold text-gray-600">Categorie da importare ({selectedTags.size}/{OSM_TAGS.length})</span>
            <div className="flex gap-3">
              <button onClick={() => setSelectedTags(new Set(OSM_TAGS.map(t => t.tag)))} className="text-xs text-emerald-600 hover:text-emerald-700 font-medium">Tutte</button>
              <button onClick={() => setSelectedTags(new Set())} className="text-xs text-gray-400 hover:text-gray-600 font-medium">Nessuna</button>
            </div>
          </div>
          <div className="flex flex-wrap gap-1.5">
            {OSM_TAGS.map(({ tag, label }) => {
              const step = steps.find(s => s.tag === tag);
              const isSel = selectedTags.has(tag);
              return (
                <button
                  key={tag}
                  onClick={() => {
                    if (running) return;
                    setSelectedTags(prev => { const n = new Set(prev); n.has(tag) ? n.delete(tag) : n.add(tag); return n; });
                  }}
                  disabled={running}
                  className={`px-2.5 py-1 rounded-full text-xs font-medium border transition-all ${
                    step?.status === 'done' ? 'bg-green-100 border-green-300 text-green-700' :
                    step?.status === 'fetching' || step?.status === 'inserting' ? 'bg-blue-100 border-blue-300 text-blue-700' :
                    step?.status === 'error' ? 'bg-red-100 border-red-300 text-red-700' :
                    isSel ? 'bg-emerald-50 border-emerald-300 text-emerald-700' :
                    'bg-gray-50 border-gray-200 text-gray-400'
                  }`}
                >
                  {(step?.status === 'fetching' || step?.status === 'inserting') && <RefreshCw className="inline w-2.5 h-2.5 mr-1 animate-spin" />}
                  {step?.status === 'done' && <CheckCircle className="inline w-2.5 h-2.5 mr-1" />}
                  {step?.status === 'error' && <XCircle className="inline w-2.5 h-2.5 mr-1" />}
                  {label}
                  {step?.status === 'done' && (step.imported ?? 0) > 0 && (
                    <span className="ml-1 font-bold text-green-600">+{step.imported}</span>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Action buttons */}
        <div className="flex items-center justify-between">
          <p className="text-xs text-gray-400">
            {comuni.length} comuni · {selectedTags.size} categorie · ~{comuni.length * selectedTags.size} query Overpass
          </p>
          {running ? (
            <button
              onClick={stopImport}
              className="flex items-center gap-2 px-5 py-2.5 bg-red-600 text-white rounded-xl text-sm font-semibold hover:bg-red-700 transition-colors"
            >
              <Square className="w-4 h-4" />
              Ferma
            </button>
          ) : (
            <button
              onClick={startImport}
              disabled={comuni.length === 0 || selectedTags.size === 0}
              className="flex items-center gap-2 px-5 py-2.5 bg-emerald-600 text-white rounded-xl text-sm font-semibold hover:bg-emerald-700 disabled:opacity-40 transition-colors"
            >
              <Play className="w-4 h-4" />
              Avvia Import
            </button>
          )}
        </div>
      </div>

      {/* ── Live progress ── */}
      {steps.length > 0 && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
          <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100">
            <div className="flex items-center gap-2">
              {running && <RefreshCw className="w-4 h-4 text-blue-500 animate-spin" />}
              <span className="font-semibold text-gray-900">
                {currentComune ? `${currentComune.city} (${currentComune.province})` : ''}
              </span>
              {comuni.length > 1 && (
                <span className="text-xs text-gray-400 bg-gray-100 px-2 py-0.5 rounded-full">
                  {comuneIndex + 1} / {comuni.length}
                </span>
              )}
            </div>
            <div className="flex items-center gap-4 text-sm">
              <span className="text-green-600 font-bold">{totalImported} importate</span>
              <span className="text-gray-400">{totalFound} trovate in OSM</span>
              {errors.length > 0 && <span className="text-red-500">{errors.length} errori</span>}
            </div>
          </div>

          {/* Progress bar */}
          <div className="h-1 bg-gray-100">
            <div className="h-full bg-emerald-500 transition-all duration-500" style={{ width: `${progress * 100}%` }} />
          </div>

          <div className="divide-y divide-gray-50 max-h-[480px] overflow-y-auto">
            {steps.map((step, i) => (
              <div
                key={i}
                className={`flex items-center justify-between px-5 py-2 text-sm ${
                  step.status === 'fetching' || step.status === 'inserting' ? 'bg-blue-50/60' :
                  step.status === 'done' && (step.imported ?? 0) > 0 ? 'bg-green-50/40' :
                  step.status === 'error' ? 'bg-red-50/40' : ''
                }`}
              >
                <div className="flex items-center gap-2">
                  {(step.status === 'fetching' || step.status === 'inserting')
                    ? <RefreshCw className="w-3.5 h-3.5 text-blue-500 animate-spin flex-shrink-0" />
                    : step.status === 'done'
                    ? <CheckCircle className="w-3.5 h-3.5 text-green-500 flex-shrink-0" />
                    : step.status === 'error'
                    ? <XCircle className="w-3.5 h-3.5 text-red-500 flex-shrink-0" />
                    : <div className="w-3.5 h-3.5 rounded-full border-2 border-gray-200 flex-shrink-0" />
                  }
                  <span className={`font-medium ${
                    step.status === 'fetching' || step.status === 'inserting' ? 'text-blue-700' :
                    step.status === 'done' ? 'text-green-700' :
                    step.status === 'error' ? 'text-red-700' : 'text-gray-400'
                  }`}>{step.label}</span>
                </div>
                <div className="text-xs tabular-nums">
                  {step.status === 'fetching' && <span className="text-blue-500">ricerca OSM...</span>}
                  {step.status === 'inserting' && <span className="text-blue-600">{step.found} trovate, salvataggio...</span>}
                  {step.status === 'done' && (
                    <span>
                      {(step.imported ?? 0) > 0
                        ? <span className="text-green-600 font-semibold">+{step.imported} nuove</span>
                        : <span className="text-gray-300">nessuna nuova</span>
                      }
                      {(step.skipped ?? 0) > 0 && <span className="text-gray-400 ml-1">· {step.skipped} già presenti</span>}
                    </span>
                  )}
                  {step.status === 'error' && <span className="text-red-500 max-w-xs truncate block">{step.error}</span>}
                </div>
              </div>
            ))}
          </div>

          {!running && done.length + errors.length === steps.length && steps.length > 0 && (
            <div className="px-6 py-4 border-t border-gray-100 bg-gray-50 flex items-center justify-between">
              <span className="text-sm text-gray-600">
                Completato — <span className="font-semibold text-green-600">{totalImported} attività importate</span>
                {errors.length > 0 && <span className="text-red-500 ml-2">· {errors.length} errori</span>}
              </span>
              <Download className="w-4 h-4 text-gray-400" />
            </div>
          )}
        </div>
      )}
    </div>
  );
}
