import 'dotenv/config';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Categorie principali e sottocategorie
const categories = [
  { name: 'Elettronica', icon: 'Smartphone', subcategories: ['Smartphone', 'Laptop', 'TV e Monitor', 'Audio e Cuffie', 'Fotocamere', 'Accessori Elettronici'] },
  { name: 'Automobili e Veicoli', icon: 'Car', subcategories: ['Auto Nuove', 'Auto Usate', 'Moto', 'Ricambi Auto', 'Accessori Auto', 'Pneumatici'] },
  { name: 'Casa e Giardino', icon: 'Home', subcategories: ['Mobili', 'Decorazioni', 'Elettrodomestici', 'Utensili da Giardino', 'Illuminazione', 'Tessili per Casa'] },
  { name: 'Alimentari e Bevande', icon: 'ShoppingCart', subcategories: ['Frutta e Verdura', 'Carne e Pesce', 'Latticini', 'Bevande', 'Snack', 'Prodotti da Forno'] },
  { name: 'Abbigliamento e Moda', icon: 'Shirt', subcategories: ['Abbigliamento Uomo', 'Abbigliamento Donna', 'Abbigliamento Bambini', 'Scarpe', 'Accessori Moda', 'Borse'] },
  { name: 'Sport e Tempo Libero', icon: 'Dumbbell', subcategories: ['Attrezzatura Fitness', 'Abbigliamento Sportivo', 'Ciclismo', 'Calcio', 'Tennis', 'Outdoor'] },
  { name: 'Salute e Bellezza', icon: 'Heart', subcategories: ['Cosmetici', 'Profumi', 'Cura della Pelle', 'Integratori', 'Prodotti per Capelli', 'Dispositivi Medici'] },
  { name: 'Libri e Media', icon: 'Book', subcategories: ['Libri', 'eBook', 'Film', 'Musica', 'Videogiochi', 'Console'] },
  { name: 'Giocattoli e Bambini', icon: 'Baby', subcategories: ['Giocattoli', 'Giochi da Tavolo', 'Abbigliamento Neonati', 'Passeggini', 'Seggiolini Auto', 'Prodotti per Allattamento'] },
  { name: 'Utensili e Ferramenta', icon: 'Wrench', subcategories: ['Utensili Manuali', 'Utensili Elettrici', 'Materiale Edile', 'Vernici', 'Sicurezza', 'Materiale Idraulico'] }
];

// Marche per ogni categoria
const brands = {
  'Elettronica': ['Samsung', 'Apple', 'LG', 'Sony', 'Huawei', 'Xiaomi', 'Dell', 'HP', 'Asus', 'Lenovo', 'Bose', 'JBL', 'Canon', 'Nikon'],
  'Automobili e Veicoli': ['Fiat', 'BMW', 'Mercedes', 'Volkswagen', 'Audi', 'Toyota', 'Honda', 'Ford', 'Renault', 'Peugeot', 'Ducati', 'Yamaha', 'Michelin', 'Pirelli'],
  'Casa e Giardino': ['IKEA', 'Leroy Merlin', 'Bosch', 'Whirlpool', 'Electrolux', 'Dyson', 'Philips', 'Black & Decker', 'Vileda', 'Rowenta'],
  'Alimentari e Bevande': ['Barilla', 'Ferrero', 'Lavazza', 'Mulino Bianco', 'Coca Cola', 'Nestlé', 'Parmalat', 'Granarolo', 'San Pellegrino', 'Galbani'],
  'Abbigliamento e Moda': ['Nike', 'Adidas', 'Zara', 'H&M', 'Gucci', 'Armani', 'Prada', 'Diesel', 'Levi\'s', 'Calvin Klein', 'Tommy Hilfiger', 'Ralph Lauren'],
  'Sport e Tempo Libero': ['Nike', 'Adidas', 'Puma', 'Decathlon', 'Under Armour', 'The North Face', 'Columbia', 'Wilson', 'Head', 'Speedo'],
  'Salute e Bellezza': ['L\'Oréal', 'Nivea', 'Garnier', 'Dove', 'Clinique', 'Lancôme', 'Chanel', 'Dior', 'Estée Lauder', 'Maybelline'],
  'Libri e Media': ['Mondadori', 'Feltrinelli', 'Rizzoli', 'Einaudi', 'PlayStation', 'Xbox', 'Nintendo', 'EA Sports', 'Ubisoft', 'Warner Bros'],
  'Giocattoli e Bambini': ['Lego', 'Mattel', 'Hasbro', 'Fisher-Price', 'Chicco', 'Peg Perego', 'Disney', 'Barbie', 'Hot Wheels', 'Playmobil'],
  'Utensili e Ferramenta': ['Bosch', 'Makita', 'Black & Decker', 'DeWalt', 'Stanley', 'Würth', 'Hilti', 'Festool', '3M', 'Milwaukee']
};

// Nomi di prodotti per ogni sottocategoria
const productTemplates = {
  'Smartphone': ['iPhone', 'Galaxy', 'Pixel', 'Redmi', 'P Series', 'Find X', 'Edge', 'Xperia'],
  'Laptop': ['MacBook', 'ThinkPad', 'XPS', 'Pavilion', 'VivoBook', 'IdeaPad', 'Inspiron', 'ZenBook'],
  'TV e Monitor': ['OLED TV', 'QLED TV', 'Smart TV', '4K Monitor', 'Gaming Monitor', 'Curved Monitor'],
  'Audio e Cuffie': ['AirPods', 'QuietComfort', 'WH Series', 'Soundbar', 'Speaker', 'Earbuds'],
  'Fotocamere': ['EOS', 'Alpha', 'Lumix', 'Z Series', 'Action Cam', 'Mirrorless', 'DSLR'],
  'Accessori Elettronici': ['Caricatore', 'Power Bank', 'Cover', 'Cavo USB', 'Adattatore', 'Mouse', 'Tastiera'],
  'Auto Nuove': ['Serie 1', '500', 'Golf', 'Clio', 'Panda', 'Corolla', 'Focus', 'A3'],
  'Auto Usate': ['Serie 3 Usata', 'Golf Usata', '500 Usata', 'Civic Usata', 'Polo Usata'],
  'Moto': ['Monster', 'R1', 'CBR', 'Ninja', 'GSX-R', 'MT', 'S1000RR'],
  'Ricambi Auto': ['Filtro Olio', 'Pastiglie Freno', 'Disco Freno', 'Candele', 'Batteria', 'Ammortizzatori'],
  'Accessori Auto': ['Tappetini', 'Coprisedili', 'Portabagagli', 'Dashcam', 'Navigatore GPS'],
  'Pneumatici': ['Pneumatico Estivo', 'Pneumatico Invernale', 'Pneumatico 4 Stagioni'],
  'Mobili': ['Divano', 'Letto', 'Armadio', 'Tavolo', 'Sedia', 'Libreria', 'Comodino'],
  'Decorazioni': ['Quadro', 'Vaso', 'Specchio', 'Tappeto', 'Cuscino', 'Candela'],
  'Elettrodomestici': ['Frigorifero', 'Lavatrice', 'Forno', 'Lavastoviglie', 'Aspirapolvere', 'Microonde'],
  'Utensili da Giardino': ['Tosaerba', 'Decespugliatore', 'Motosega', 'Idropulitrice', 'Tagliasiepi'],
  'Illuminazione': ['Lampadario', 'Lampada da Tavolo', 'Faretto LED', 'Striscia LED', 'Applique'],
  'Tessili per Casa': ['Lenzuola', 'Copripiumino', 'Asciugamano', 'Tovaglia', 'Tenda'],
  'Frutta e Verdura': ['Mele', 'Banane', 'Arance', 'Pomodori', 'Patate', 'Carote', 'Insalata'],
  'Carne e Pesce': ['Petto di Pollo', 'Bistecca', 'Salmone', 'Tonno', 'Prosciutto', 'Salame'],
  'Latticini': ['Latte', 'Yogurt', 'Formaggio', 'Mozzarella', 'Parmigiano', 'Burro'],
  'Bevande': ['Acqua Minerale', 'Coca Cola', 'Caffè', 'Tè', 'Succo di Frutta', 'Birra', 'Vino'],
  'Snack': ['Patatine', 'Cioccolato', 'Biscotti', 'Crackers', 'Barrette', 'Caramelle'],
  'Prodotti da Forno': ['Pane', 'Pasta', 'Farina', 'Cornflakes', 'Fette Biscottate', 'Grissini'],
  'Abbigliamento Uomo': ['T-Shirt', 'Camicia', 'Jeans', 'Giacca', 'Maglione', 'Pantaloni'],
  'Abbigliamento Donna': ['Vestito', 'Gonna', 'Blusa', 'Jeans', 'Giacca', 'Cardigan'],
  'Abbigliamento Bambini': ['Tutina', 'Felpa', 'Pantaloni', 'T-Shirt', 'Giacca'],
  'Scarpe': ['Sneakers', 'Stivali', 'Sandali', 'Mocassini', 'Scarpe da Ginnastica', 'Décolleté'],
  'Accessori Moda': ['Borsa', 'Cintura', 'Sciarpa', 'Cappello', 'Occhiali da Sole', 'Orologio'],
  'Borse': ['Zaino', 'Borsa a Tracolla', 'Portafoglio', 'Trolley', 'Marsupio'],
  'Attrezzatura Fitness': ['Tapis Roulant', 'Cyclette', 'Pesi', 'Panca', 'Ellittica', 'Tappetino Yoga'],
  'Abbigliamento Sportivo': ['Scarpe Running', 'Leggings', 'Canotta', 'Pantaloncini', 'Giacca Sportiva'],
  'Ciclismo': ['Bici da Corsa', 'Mountain Bike', 'Casco', 'Borraccia', 'GPS Bike'],
  'Calcio': ['Pallone', 'Scarpe da Calcio', 'Parastinchi', 'Divisa', 'Guanti Portiere'],
  'Tennis': ['Racchetta', 'Palline', 'Scarpe Tennis', 'Borsa Tennis'],
  'Outdoor': ['Tenda', 'Sacco a Pelo', 'Zaino Trekking', 'Scarponi', 'Giacca Impermeabile'],
  'Cosmetici': ['Fondotinta', 'Rossetto', 'Mascara', 'Ombretto', 'Correttore', 'Primer'],
  'Profumi': ['Eau de Parfum', 'Eau de Toilette', 'Colonia', 'Profumo'],
  'Cura della Pelle': ['Crema Viso', 'Siero', 'Maschera', 'Tonico', 'Detergente'],
  'Integratori': ['Multivitaminico', 'Vitamina C', 'Omega 3', 'Probiotici', 'Magnesio'],
  'Prodotti per Capelli': ['Shampoo', 'Balsamo', 'Maschera Capelli', 'Tintura', 'Lacca'],
  'Dispositivi Medici': ['Termometro', 'Saturimetro', 'Misuratore Pressione', 'Aerosol'],
  'Libri': ['Romanzo', 'Thriller', 'Fantasy', 'Biografia', 'Saggio', 'Manuale'],
  'eBook': ['eBook Romanzo', 'eBook Thriller', 'eBook Fantasy'],
  'Film': ['DVD', 'Blu-ray', 'Box Set', 'Film 4K'],
  'Musica': ['CD', 'Vinile', 'Box Set Musicale'],
  'Videogiochi': ['FIFA', 'Call of Duty', 'The Last of Us', 'Spider-Man', 'Mario Kart', 'Zelda'],
  'Console': ['PlayStation 5', 'Xbox Series X', 'Nintendo Switch', 'Controller'],
  'Giocattoli': ['Peluche', 'Bambola', 'Puzzle', 'Costruzioni', 'Auto Telecomandata'],
  'Giochi da Tavolo': ['Monopoly', 'Risiko', 'Scarabeo', 'Cluedo', 'Uno'],
  'Abbigliamento Neonati': ['Body', 'Tutina', 'Copertina', 'Cappellino', 'Calzini'],
  'Passeggini': ['Passeggino Trio', 'Passeggino Leggero', 'Passeggino Doppio'],
  'Seggiolini Auto': ['Seggiolino Gruppo 0+', 'Seggiolino Gruppo 1', 'Seggiolino Gruppo 2/3'],
  'Prodotti per Allattamento': ['Biberon', 'Sterilizzatore', 'Tiralatte', 'Scalda Biberon'],
  'Utensili Manuali': ['Martello', 'Cacciavite', 'Chiave Inglese', 'Pinza', 'Livella', 'Metro'],
  'Utensili Elettrici': ['Trapano', 'Avvitatore', 'Smerigliatrice', 'Sega Circolare', 'Levigatrice'],
  'Materiale Edile': ['Cemento', 'Malta', 'Mattoni', 'Piastrelle', 'Tegole'],
  'Vernici': ['Vernice Murale', 'Smalto', 'Impregnante', 'Primer', 'Vernice Spray'],
  'Sicurezza': ['Guanti da Lavoro', 'Occhiali Protettivi', 'Maschera', 'Casco', 'Scarpe Antinfortunistica'],
  'Materiale Idraulico': ['Rubinetto', 'Tubo', 'Raccordo', 'Valvola', 'Sifone']
};

function slugify(text) {
  return text
    .toLowerCase()
    .replace(/[àáâãäå]/g, 'a')
    .replace(/[èéêë]/g, 'e')
    .replace(/[ìíîï]/g, 'i')
    .replace(/[òóôõö]/g, 'o')
    .replace(/[ùúûü]/g, 'u')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function generateRandomPrice(min, max) {
  return (Math.random() * (max - min) + min).toFixed(2);
}

function generateSKU() {
  return 'SKU-' + Math.random().toString(36).substr(2, 9).toUpperCase();
}

function generateBarcode() {
  return '80' + Math.floor(Math.random() * 10000000000000).toString().padStart(11, '0');
}

async function seedCategories() {
  console.log('🏷️  Seeding categories...');

  const categoryMap = new Map();

  for (const category of categories) {
    const mainSlug = slugify(category.name);

    const { data: mainCategory, error: mainError } = await supabase
      .from('product_categories')
      .insert({
        name: category.name,
        slug: mainSlug,
        icon: category.icon,
        display_order: categories.indexOf(category)
      })
      .select()
      .single();

    if (mainError) {
      console.error(`Error creating category ${category.name}:`, mainError);
      continue;
    }

    categoryMap.set(category.name, mainCategory.id);
    console.log(`✓ Created main category: ${category.name}`);

    for (const subcategory of category.subcategories) {
      const subSlug = slugify(subcategory);

      const { data: subCategory, error: subError } = await supabase
        .from('product_categories')
        .insert({
          name: subcategory,
          slug: subSlug,
          parent_id: mainCategory.id,
          display_order: category.subcategories.indexOf(subcategory)
        })
        .select()
        .single();

      if (subError) {
        console.error(`Error creating subcategory ${subcategory}:`, subError);
        continue;
      }

      categoryMap.set(subcategory, subCategory.id);
      console.log(`  ✓ Created subcategory: ${subcategory}`);
    }
  }

  return categoryMap;
}

async function seedBrands() {
  console.log('\n🏭 Seeding brands...');

  const brandMap = new Map();
  const allBrands = new Set();

  Object.values(brands).forEach(brandList => {
    brandList.forEach(brand => allBrands.add(brand));
  });

  for (const brandName of allBrands) {
    const slug = slugify(brandName);

    const { data: brand, error } = await supabase
      .from('product_brands')
      .insert({
        name: brandName,
        slug: slug
      })
      .select()
      .single();

    if (error) {
      console.error(`Error creating brand ${brandName}:`, error);
      continue;
    }

    brandMap.set(brandName, brand.id);
    console.log(`✓ Created brand: ${brandName}`);
  }

  return brandMap;
}

async function seedProducts(categoryMap, brandMap, totalProducts = 300000) {
  console.log(`\n📦 Seeding ${totalProducts} products...`);

  const batchSize = 1000;
  let productsCreated = 0;

  const subcategories = [];
  categories.forEach(cat => {
    cat.subcategories.forEach(sub => {
      subcategories.push({ name: sub, parent: cat.name });
    });
  });

  const productsPerSubcategory = Math.ceil(totalProducts / subcategories.length);

  for (const subcategory of subcategories) {
    const categoryId = categoryMap.get(subcategory.name);
    if (!categoryId) continue;

    const availableBrands = brands[subcategory.parent] || [];
    if (availableBrands.length === 0) continue;

    const templates = productTemplates[subcategory.name] || ['Prodotto'];

    console.log(`\n📂 Creating products for: ${subcategory.name}`);

    for (let i = 0; i < productsPerSubcategory; i += batchSize) {
      const batch = [];
      const currentBatchSize = Math.min(batchSize, productsPerSubcategory - i);

      for (let j = 0; j < currentBatchSize; j++) {
        const template = templates[Math.floor(Math.random() * templates.length)];
        const brand = availableBrands[Math.floor(Math.random() * availableBrands.length)];
        const brandId = brandMap.get(brand);

        if (!brandId) continue;

        const variation = Math.random() > 0.5 ? ` ${Math.floor(Math.random() * 20) + 1}` : '';
        const model = Math.random() > 0.5 ? ` ${['Pro', 'Plus', 'Max', 'Ultra', 'Lite', 'Mini', 'Premium'][Math.floor(Math.random() * 7)]}` : '';
        const productName = `${brand} ${template}${variation}${model}`;

        const sku = generateSKU();
        const slug = slugify(productName) + '-' + sku.toLowerCase();

        const price = parseFloat(generateRandomPrice(5, 2000));
        const hasDiscount = Math.random() > 0.7;
        const originalPrice = hasDiscount ? parseFloat((price * (1 + Math.random() * 0.3)).toFixed(2)) : null;

        const stockQuantity = Math.floor(Math.random() * 200);
        const isAvailable = stockQuantity > 0;

        const ratingAverage = parseFloat((Math.random() * 2 + 3).toFixed(1));
        const ratingCount = Math.floor(Math.random() * 500);

        batch.push({
          name: productName,
          slug: slug,
          description: `${productName} - Prodotto di alta qualità della marca ${brand}`,
          category_id: categoryId,
          brand_id: brandId,
          sku: sku,
          barcode: generateBarcode(),
          price: price,
          original_price: originalPrice,
          currency: 'EUR',
          stock_quantity: stockQuantity,
          is_available: isAvailable,
          images: [],
          specifications: {},
          rating_average: ratingAverage,
          rating_count: ratingCount,
          view_count: Math.floor(Math.random() * 1000)
        });
      }

      const { error } = await supabase
        .from('products')
        .insert(batch);

      if (error) {
        console.error(`Error creating batch for ${subcategory.name}:`, error);
        continue;
      }

      productsCreated += batch.length;
      console.log(`  ✓ Created ${productsCreated.toLocaleString()}/${totalProducts.toLocaleString()} products (${((productsCreated/totalProducts)*100).toFixed(1)}%)`);
    }
  }

  console.log(`\n✅ Successfully created ${productsCreated.toLocaleString()} products!`);
}

async function main() {
  console.log('🚀 Starting product seeding process...\n');

  try {
    const categoryMap = await seedCategories();
    const brandMap = await seedBrands();
    await seedProducts(categoryMap, brandMap, 300000);

    console.log('\n✅ Product seeding completed successfully!');
  } catch (error) {
    console.error('\n❌ Error during seeding:', error);
    process.exit(1);
  }
}

main();
