// Script to generate SQL for seeding businesses across all Italian regions

const regions = {
  'Abruzzo': { cities: [['LAquila', 'AQ', '67100'], ['Pescara', 'PE', '65100'], ['Teramo', 'TE', '64100'], ['Chieti', 'CH', '66100']], phonePrefix: '085', vatStart: 40000000000 },
  'Basilicata': { cities: [['Potenza', 'PZ', '85100'], ['Matera', 'MT', '75100']], phonePrefix: '097', vatStart: 41000000000 },
  'Calabria': { cities: [['Catanzaro', 'CZ', '88100'], ['Reggio Calabria', 'RC', '89100'], ['Cosenza', 'CS', '87100']], phonePrefix: '096', vatStart: 42000000000 },
  'Friuli-Venezia Giulia': { cities: [['Trieste', 'TS', '34100'], ['Udine', 'UD', '33100'], ['Pordenone', 'PN', '33170'], ['Gorizia', 'GO', '34170']], phonePrefix: '040', vatStart: 43000000000 },
  'Liguria': { cities: [['Genova', 'GE', '16100'], ['La Spezia', 'SP', '19100'], ['Savona', 'SV', '17100'], ['Imperia', 'IM', '18100']], phonePrefix: '010', vatStart: 44000000000 },
  'Marche': { cities: [['Ancona', 'AN', '60100'], ['Pesaro', 'PU', '61100'], ['Macerata', 'MC', '62100'], ['Ascoli Piceno', 'AP', '63100']], phonePrefix: '071', vatStart: 45000000000 },
  'Molise': { cities: [['Campobasso', 'CB', '86100'], ['Isernia', 'IS', '86170']], phonePrefix: '087', vatStart: 46000000000 },
  'Puglia': { cities: [['Bari', 'BA', '70100'], ['Lecce', 'LE', '73100'], ['Taranto', 'TA', '74100'], ['Foggia', 'FG', '71100'], ['Brindisi', 'BR', '72100']], phonePrefix: '080', vatStart: 47000000000 },
  'Sardegna': { cities: [['Cagliari', 'CA', '09100'], ['Sassari', 'SS', '07100'], ['Olbia', 'SS', '07026'], ['Nuoro', 'NU', '08100']], phonePrefix: '070', vatStart: 48000000000 },
  'Trentino-Alto Adige': { cities: [['Trento', 'TN', '38100'], ['Bolzano', 'BZ', '39100']], phonePrefix: '046', vatStart: 49000000000 },
  'Umbria': { cities: [['Perugia', 'PG', '06100'], ['Terni', 'TR', '05100']], phonePrefix: '075', vatStart: 50000000000 },
  'Valle dAosta': { cities: [['Aosta', 'AO', '11100']], phonePrefix: '016', vatStart: 51000000000 }
};

const categories = [
  { slug: 'ristoranti', names: ['Ristorante', 'Trattoria', 'Osteria'] },
  { slug: 'pizzerie', names: ['Pizzeria'] },
  { slug: 'bar-caffe', names: ['Bar', 'Caffe', 'Bar Pasticceria'] },
  { slug: 'studi-dentistici', names: ['Studio Dentistico'] },
  { slug: 'studi-medici', names: ['Studio Medico', 'Poliambulatorio'] },
  { slug: 'farmacie', names: ['Farmacia'] },
  { slug: 'avvocati', names: ['Studio Legale', 'Avvocato'] },
  { slug: 'commercialisti', names: ['Studio Commercialisti', 'Commercialista'] },
  { slug: 'notai', names: ['Notaio'] },
  { slug: 'parrucchieri', names: ['Parrucchiere', 'Salone'] },
  { slug: 'centri-estetici', names: ['Centro Estetico'] },
  { slug: 'idraulici', names: ['Idraulico'] },
  { slug: 'elettricisti', names: ['Elettricista'] },
  { slug: 'imbianchini', names: ['Imbianchino'] },
  { slug: 'fabbri', names: ['Fabbro'] },
  { slug: 'falegnami', names: ['Falegname'] },
  { slug: 'supermercati', names: ['Supermercato'] },
  { slug: 'ferramenta', names: ['Ferramenta'] },
  { slug: 'palestre', names: ['Palestra'] },
  { slug: 'panifici', names: ['Panificio'] },
  { slug: 'gelaterie-pasticcerie', names: ['Pasticceria', 'Gelateria'] },
  { slug: 'veterinari', names: ['Veterinario'] },
  { slug: 'macellerie', names: ['Macelleria'] },
  { slug: 'pescherie', names: ['Pescheria'] },
  { slug: 'librerie', names: ['Libreria'] },
  { slug: 'architetti', names: ['Studio Architetti', 'Architetto'] },
  { slug: 'ingegneri', names: ['Studio Ingegneri', 'Ingegnere'] },
  { slug: 'geometri', names: ['Geometra'] },
  { slug: 'officine-auto', names: ['Officina Auto'] },
  { slug: 'gommisti', names: ['Gommista'] }
];

const streets = ['Via Roma', 'Corso Italia', 'Piazza Garibaldi', 'Via Mazzini', 'Corso Vittorio Emanuele', 'Via Cavour', 'Via Dante', 'Piazza del Duomo', 'Via Verdi', 'Corso Umberto'];

let vatCounter = 0;
console.log("-- Generated businesses for all Italian regions");
console.log("");

Object.keys(regions).forEach(regionName => {
  const region = regions[regionName];
  console.log(`-- ${regionName.toUpperCase()}`);

  region.cities.forEach((cityData, cityIndex) => {
    const [city, province, postalCode] = cityData;

    categories.forEach((cat, catIndex) => {
      const nameTemplate = cat.names[Math.floor(Math.random() * cat.names.length)];
      const street = streets[Math.floor(Math.random() * streets.length)];
      const streetNumber = Math.floor(Math.random() * 200) + 1;
      const phone = `${region.phonePrefix}${345000 + vatCounter}`;
      const mobile = `333${1234000 + vatCounter}`;
      const usedPhone = ['idraulici', 'elettricisti', 'imbianchini', 'fabbri', 'falegnami'].includes(cat.slug) ? mobile : phone;
      const vat = (region.vatStart + vatCounter).toString();
      const email = `${nameTemplate.toLowerCase().replace(/ /g, '')}${vatCounter}@email.it`;

      console.log(`INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('${nameTemplate} ${city}', (SELECT id FROM business_categories WHERE slug = '${cat.slug}'), false, true, '${vat}', '${email}', '${usedPhone}');`);
      console.log(`INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '${vat}'), 'Sede Principale', '${street}', '${streetNumber}', '${city}', '${province}', '${postalCode}', '${usedPhone}', '${email}', '${vat}', true);`);
      console.log("");

      vatCounter++;
    });
  });
});

console.log(`-- Total businesses generated: ${vatCounter}`);
