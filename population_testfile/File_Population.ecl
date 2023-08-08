IMPORT STD;
//EXPORT File_Population := MODULE
Layout := RECORD

string SUMLEV;
string STATE;
string COUNTY;
string PLACE;
string COUSUB;
string CONCIT;
string PRIMGEO_FLAG;
string FUNCSTAT;
string NAME;
string STNAME;
string ESTIMATESBASE2020;
string POPESTIMATE2020;
string POPESTIMATE2021;
string POPESTIMATE2022;

END;

File_Population:= DATASET('~test::ns::nivedha::population_fixed::population.csv', Layout, CSV(HEADING(1)));

File_Population;

Layout_two := RECORD

string9 SUMLEV;
string5 STATE;
string6 COUNTY;
string5 PLACE;
string6 COUSUB;
string6 CONCIT;
string12 PRIMGEO_FLAG;
string8 FUNCSTAT;
string57 NAME;
string20 STNAME;
string17 ESTIMATESBASE2020;
string15 POPESTIMATE2020;
string15 POPESTIMATE2021;
string15 POPESTIMATE2022;

END;




file_population_fixed := project(File_Population,Layout_two);



output(file_population_fixed,,'~test::ns::nivedha::population_fixed',thor,overwrite);
