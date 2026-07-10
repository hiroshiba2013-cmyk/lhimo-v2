/*
  # Fix province names in comuni_italiani to match ITALIAN_PROVINCES list

  Normalizes province names from ISTAT format to the app's standard format
  so the dropdown filter works correctly.

  Changes:
  - 'Bolzano/Bozen' -> 'Bolzano'
  - 'Forl-Cesena' -> 'Forlì-Cesena'
  - 'Monza e della Brianza' -> 'Monza e Brianza'
  - "Reggio nell'Emilia" -> 'Reggio Emilia'
  - "Valle d'Aosta/Valle d'Aoste" -> "Valle d'Aosta"
*/

UPDATE comuni_italiani SET provincia = 'Bolzano', sigla = 'BZ' WHERE provincia = 'Bolzano/Bozen';
UPDATE comuni_italiani SET provincia = 'Forlì-Cesena', sigla = 'FC' WHERE provincia = 'Forl-Cesena';
UPDATE comuni_italiani SET provincia = 'Monza e Brianza', sigla = 'MB' WHERE provincia = 'Monza e della Brianza';
UPDATE comuni_italiani SET provincia = 'Reggio Emilia', sigla = 'RE' WHERE provincia = 'Reggio nell''Emilia';
UPDATE comuni_italiani SET provincia = 'Valle d''Aosta', sigla = 'AO' WHERE provincia = 'Valle d''Aosta/Valle d''Aoste';
