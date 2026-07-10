import { supabase } from './lib/supabase';

async function fetchData() {
  const { data, error } = await supabase
    .from('your_table_name')
    .select('*');

  if (error) {
    console.error('Errore:', error);
    return;
  }

  console.log('Dati:', data);
}

async function insertData() {
  const { data, error } = await supabase
    .from('your_table_name')
    .insert([
      { column1: 'valore1', column2: 'valore2' }
    ])
    .select();

  if (error) {
    console.error('Errore:', error);
    return;
  }

  console.log('Dati inseriti:', data);
}

async function updateData() {
  const { data, error } = await supabase
    .from('your_table_name')
    .update({ column1: 'nuovo_valore' })
    .eq('id', 1)
    .select();

  if (error) {
    console.error('Errore:', error);
    return;
  }

  console.log('Dati aggiornati:', data);
}

async function deleteData() {
  const { error } = await supabase
    .from('your_table_name')
    .delete()
    .eq('id', 1);

  if (error) {
    console.error('Errore:', error);
    return;
  }

  console.log('Dati eliminati');
}
