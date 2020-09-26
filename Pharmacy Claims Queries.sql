use claims;

#assigning keys 

ALTER TABLE drugs
MODIFY COLUMN drug_ndc VARCHAR(100);

ALTER TABLE facttable
MODIFY COLUMN drug_ndc VARCHAR(100);

alter table facttable
ADD uid INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

alter table drugs
ADD CONSTRAINT drug_ndc_fk PRIMARY KEY (drug_ndc);

alter table facttable
add constraint drug_ndc_fk1 foreign key (drug_ndc) references drugs(drug_ndc) 
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE drugbrand
MODIFY COLUMN drug_brand_generic_code CHAR(2);

ALTER TABLE drugs
MODIFY COLUMN drug_brand_generic_code CHAR(2);

alter table drugbrand
ADD CONSTRAINT drug_brand_fk PRIMARY KEY (drug_brand_generic_code);

alter table drugs 
add constraint drug_ndc_fk3 foreign key (drug_brand_generic_code) references drugbrand(drug_brand_generic_code) 
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE drugform
MODIFY COLUMN drug_form_code CHAR(2);

ALTER TABLE drugs
MODIFY COLUMN drug_form_code CHAR(2);

alter table drugform
ADD CONSTRAINT drug_brand_form_code_fk PRIMARY KEY (drug_form_code);

alter table drugs 
add constraint drug_brand_form_code_fk foreign key (drug_form_code) references drugform(drug_form_code) 
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE facttable
MODIFY COLUMN member_id VARCHAR(10);

ALTER TABLE memberdetails
MODIFY COLUMN member_id VARCHAR(10);

alter table memberdetails
ADD CONSTRAINT member_id_fk PRIMARY KEY (member_id);

alter table facttable 
add constraint member_id_fk foreign key (member_id) references memberdetails(member_id) 
ON DELETE RESTRICT
ON UPDATE RESTRICT;

#Part 4

#1)
SELECT drug_name as Drug_Name, COUNT(*) AS Num_of_Pres FROM drugs
inner join facttable f on drugs.drug_ndc=f.drug_ndc
GROUP BY drug_name
ORDER BY drug_name asc;

#2)

SELECT COUNT(facttable.uid) AS Total_Prescriptions, COUNT(DISTINCT facttable.member_id) AS Member, SUM(facttable.copay) AS Total_copay,SUM(facttable.insurancepaid) AS Total_insurancepaid,
CASE WHEN memberdetails.member_age > 65 then "Aged 65+"
WHEN memberdetails.member_age < 65 then "Aged <65"
end as Age_Category 
FROM facttable 
INNER JOIN memberdetails  ON facttable.member_id = memberdetails.member_id 
GROUP BY Age_Category;

#3


CREATE TABLE most_recent AS
SELECT facttable.member_id,facttable.fill_date,facttable.insurancepaid,memberdetails.member_first_name as Member_First_Name,memberdetails.member_last_name as Member_Last_Name,drugs.drug_name,row_number() OVER (PARTITION BY facttable.member_id ORDER BY facttable.fill_date ASC) AS FLAG 
FROM facttable 
LEFT JOIN memberdetails ON facttable.member_id=memberdetails.member_id
LEFT JOIN drugs ON facttable.drug_ndc=drugs.drug_ndc;

select * from most_recent;

SELECT member_id, Member_first_name, Member_last_name, drug_name, fill_date, insurancepaid FROM most_recent WHERE FLAG=1;


