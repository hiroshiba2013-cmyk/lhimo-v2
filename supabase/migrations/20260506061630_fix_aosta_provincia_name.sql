/*
  # Fix provincia name for Valle d'Aosta comuni

  The province name should be 'Aosta' (the actual province, sigla AO),
  not 'Valle d'Aosta' which is the region name.
*/

UPDATE comuni_italiani SET provincia = 'Aosta' WHERE provincia = 'Valle d''Aosta';
