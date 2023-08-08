/*--SOAP--
<message name="CitiesByStateSearch_nodelay" fast_display="true">
  <part name="City" type="xsd:string"/>
  <part name="State" type="xsd:string"/>
  <part name="County" type="xsd:string"/>
  <part name="UniqueRecords" type="xsd:boolean"/>
  <part name="include_population" type="xsd:boolean"/>
  <part name="ShowRecordsWithPopulation" type="xsd:boolean"/>
 </message>
*/
/*--INFO--
This service will list counties, city on selected state.
*/

export CitiesAndPopulation() := macro
import std;


Layout_Batch_In := record
  string25  city;
  string2   st;
  string25   county;
  boolean UniqueRecords;
  boolean include_population;
  boolean ShowRecordsWithPopulation;
end;

string25 city_val := '' : stored('City');
string2 st_val := '' : stored('State');
string25 county_val := '' : stored('county');
boolean unique_val := false : stored('UniqueRecords');
boolean pop_info_val := false : stored('include_population');
boolean pop_recs_val := false : stored('ShowRecordsWithPopulation');

Layout_Batch_In setupAddr() := transform
 
  self.city := std.Str.ToUpperCase(city_val);
  self.st := std.Str.ToUpperCase(st_val);
  self.county := std.Str.ToUpperCase(county_val);
  self.UniqueRecords := unique_val;
  self.include_population := pop_info_val;
  self.ShowRecordsWithPopulation := pop_recs_val;
end;

addr_in := dataset([setupAddr()]);
output(addr_in);
rec:=RECORD
  string60 state;
  string60 city;
  string2 st;
  string60 county;
  unsigned8 __internal_fpos__;
 END;
 

ds:=dataset([],rec);
df:='~hugo::key::stcitycounty::data::million::ALL';
df:='~hugo::key::stcitycounty::data::million::' +s_st;

ds_statecity := index(ds,{state,city},{rec-state-city},df);
//output(ds_statecity);

rec2 := RECORD
string20 STNAME;
string57 NAME;
string9 SUMLEV;
string5 STATE;
string6 COUNTY;
string5 PLACE;
string6 COUSUB;
string6 CONCIT;
string12 PRIMGEO_FLAG;
string8 FUNCSTAT;
string17 ESTIMATESBASE2020;
string15 POPESTIMATE2020;
string15 POPESTIMATE2021;
string15 POPESTIMATE2022;
unsigned8 __internal_fpos__;
END;

ds_2:= dataset([],rec2);
// ds_2:= dataset('~test::ns::nivedha::population_fixed',rec2);
ds_pop:='~hugo::key::population::payload::state::onemil';
ds_population := index(ds_2,{STNAME,NAME},{ds_2},ds_pop);


record_out:=RECORD
    STRING60 state;
    STRING60 city;
    STRING2 st;
    STRING60 county;
    string20 STNAME;
string57 NAME;
    string9 SUMLEV;
string5 PLACE;
string6 COUSUB;
string6 CONCIT;
string12 PRIMGEO_FLAG;
string8 FUNCSTAT;
string17 ESTIMATESBASE2020;
string15 POPESTIMATE2020;
string15 POPESTIMATE2021;
string15 POPESTIMATE2022;
    
END;

ds_statecity_prop:=join(ds_statecity,ds_population,
 //left.state=right.stname and STD.Str.FindWord(right.name, left.city, true),
  left.state=right.stname AND STD.Str.SplitWords(right.name,' ')[1]=left.city,
//STD.Str.Contains( source, pattern, nocase ) 
TRANSFORM(record_out, SELF := LEFT,SELF:=RIGHT),left outer);


final_out := join(ds_statecity_prop,addr_in,
								(left.st = right.st) and
								(left.city=right.city or right.city='') and
								(left.county=right.county or right.county=''), 
								TRANSFORM(record_out, SELF := LEFT,SELF:=[])); 
                

output(addr_in,named('Input')); 
output(sort(if(unique_val,final_out,final_out),city,county), named ('Results'));

//left.city=right.name


ENDMACRO;
