-- complete table querry

SELECT 
	o.name, o.occupation, o.age, o.median_salary AS salary,
	h.address, h.city, h.zip_code, h.price, h.mortgage,
	t.status, t.transac_date
FROM owners AS o
LEFT JOIN houses AS h
ON o.owner_id = h.owner_id
JOIN transactions as t
ON o.owner_id = t.buyer_id