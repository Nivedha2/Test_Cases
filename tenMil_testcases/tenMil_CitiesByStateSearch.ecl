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

export tenMil_CitiesByStateSearch() := macro
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
df:='~attila::key::stcitycounty::data::testmillion';
ds_statecity := index(ds,{state,city},{rec-state-city},df);
//output(ds_statecity);

record_out:=RECORD
    STRING60 state;
    STRING60 city;
    STRING2 st;
    STRING60 county;
END;

final_out := join(ds_statecity,addr_in,
								(left.st = right.st) and
								(left.city=right.city or right.city='') and
								(left.county=right.county or right.county=''), 
								TRANSFORM(record_out, SELF := LEFT,SELF:=[])); // doesn't display internal fpos, unique records, includue population, showrecordwithpopulation 
                                                               // adds them to an empty list

output(addr_in,named('Input')); // addr_in record set used to store the user's inputs
output(sort(if(unique_val,final_out,final_out),city,county), named ('Results'));



ENDMACRO;
