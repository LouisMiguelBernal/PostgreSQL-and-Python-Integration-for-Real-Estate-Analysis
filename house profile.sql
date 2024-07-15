SELECT 
	h.address, h.city, h.state, o.name AS owner,
	t.status, h.mortgage, h.price, t.transac_date
FROm houses AS h
LEFT JOIN owners AS o
ON h.owner_id = o.owner_id
JOIN transactions as t
ON t.buyer_id = h.owner_id