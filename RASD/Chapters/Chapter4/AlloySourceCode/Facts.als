//RELATION BETWEEN AGRONOMIST AND MANDAL

//Mandal is associated to a unique Agronomist
fact { all disj m1, m2: Mandal | m1.agronomist != m2.agronomist }

//Agronomist is associated to a unique Mandal
fact { all disj a1, a2: Agronomist | a1.mandal != a2.mandal }

//Mandal and Agronomist are related
fact { all a: Agronomist, m: Mandal |  a.mandal = m implies m.agronomist = a }

//RELATION BETWEEN MANDAL AND FARMER

//Two Farmer (or more) can be associated to the same Mandal
fact { some disj f1, f2: Farmer | f1.mandal = f2.mandal }

//Mandal and Farmer are related
fact { all f: Farmer, m: Mandal |  f.mandal = m implies f in m.farmer }
fact { all f: Farmer, m: Mandal |  f in m.farmer implies  f.mandal = m }

//DISCUSSION FORUM 

//For each Farmer the set of Thread must be different
fact { all disj f1, f2: Farmer | f1.thread & f2.thread = none }

//For each Farmer the set of Post must be different
fact { all disj f1, f2: Farmer | f1.post & f2.post = none }

//For each Thread the set of Post must be different 
fact { all disj t1, t2: Thread | t1.post & t2.post = none }

//The responder must not be the Farmer who made the thread
fact { all t: Thread, p: Post | t.id = p.id implies p.responder != t.questionner }

//A Thread belongs to the Thread set of the Thread questionner
fact { all t: Thread |  t in t.questionner.thread }

//A Post belongs to the Post set of the Post responder
fact { all p: Post |  p in p.responder.post }

//All Thread belong to one Forum
fact { all t: Thread, df: Forum |  t in df.thread }

//Each Thread is associated to a unique id
fact uniqueThread{ all disj t1, t2: Thread | t1.id != t2.id }

//A Post cannot exist without an associated Thread
fact { all p: Post, t: Thread| p.id = t.id implies p in t.post }

//Each Post must be related to the corresponding Thread
fact { no p: Post | all t: Thread | p.id != t.id }

//Two Post (or more) can be associated to the same Thread
fact { some disj p1, p2: Post | p1.id = p2.id }

//Two Thread (or more) can have the same questionner 
fact { some disj t1, t2: Thread |  t1.questionner = t2.questionner }

//DAILY PLAN

//For each Agronomist the set of DailyPlan must be different
fact { all disj a1, a2: Agronomist | a1.dailyPlan & a2.dailyPlan = none }

//For each Farmer the set of Visit must be different 
fact { all disj f1, f2: Farmer | f1.visit & f2.visit = none }

//For each DailyPlan the set of Visit must be different 
fact { all disj d1, d2: DailyPlan | d1.visit & d2.visit = none }

//A DailyPlan cannot exist without the associated Agronomist
fact { all a: Agronomist, d: DailyPlan | d.agronomist = a implies d in a.dailyPlan }

//DailyPlan is associated to a unique Agronomist
fact { all disj d1, d2: DailyPlan | d1.agronomist != d2.agronomist }

//A Visit is associated to a DailyPlan 
fact { all v: Visit, d: DailyPlan, a: Agronomist | v.farmer.mandal.agronomist = a and d.agronomist = a and v.day = d.day implies v.dailyPlan = d }

//A Visit cannot exist without the associated DailyPlan
fact { all v: Visit, d: DailyPlan | v.dailyPlan = d implies v in d.visit }

//A Visit cannot exist without the associated Farmer
fact { all v: Visit, f: Farmer | v.farmer = f  implies v.dailyPlan.agronomist = f.mandal.agronomist }

//Visit and Farmer are related
fact { all f: Farmer, v: Visit | v.farmer = f  implies v in f.visit }

//A Visit refers only to one Farmer
fact { all v: Visit | ( no disj f1 , f2: Farmer | v in f1.visit and v in f2.visit ) }

//Farmer cannot have two Visit in the same day
fact { all f: Farmer | ( no disj v1 , v2: Visit | v1.day = v2.day and v1.dailyPlan.agronomist = v2.dailyPlan.agronomist and v1.farmer = f and v2.farmer = f ) }

//Two DailyPlan (or more) can have the same day or state 
fact { some disj d1, d2: DailyPlan | d1.day = d2.day or d1.state = d2.state }

//Two DailyPlan having the same day cannot have the same Agronomist
fact { all disj d1, d2: DailyPlan | d1.day = d2.day implies d1.agronomist != d2.agronomist }

//Two DailyPlan having different day can have the same Agronomist
fact { some disj d1, d2: DailyPlan | d1.day != d2.day implies d1.agronomist = d2.agronomist }

//All Visit associated to the same DailyPlan must have different hour
fact { all disj v1, v2: Visit | v1.day = v2.day implies v1.hour != v2.hour }

//Two Visit (or more) can be associated to the same Farmer or Status 
fact { some disj v1, v2: Visit |  v1.farmer = v2.farmer or v1.status = v2.status }

// If a DailyPlan exists it must be CREATED, UPDATED or CONFIRMED
fact { all d: DailyPlan | d.state = GENERATED or d.state = UPDATED or d.state = CONFIRMED }

// If a Visit exists it must be SCHEDULED or DONE
fact { all v: Visit | v.status = SCHEDULED or v.status = DONE }

//If DailyPlan's State is CREATED for a certain day, associated Visit's Status is SCHEDULED
fact { all v: Visit | v.dailyPlan.state = GENERATED implies v.status = SCHEDULED and v.dailyPlan.deviation = none }

//If DailyPlan's State is UPDATED for a certain day, associated Visit's Status is SCHEDULED
fact { all v: Visit | v.dailyPlan.state = UPDATED implies v.status = SCHEDULED and v.dailyPlan.deviation = none}

//If DailyPlan's State is UPDATED, associated Visit's date is modified according to the update
fact { all v: Visit | v.dailyPlan.state = UPDATED and v.dailyPlan.state.selectedHour = v.hour implies v.dailyPlan.state.updateDay != none and v.dailyPlan.state.updateHour != none and v.hour = v.dailyPlan.state.updateHour and v.day = v.dailyPlan.state.updateDay and v.status = SCHEDULED }

//DailyPlan's State is UPDATED adding a new Visit
fact { all d: DailyPlan, v: Visit, f: Farmer | d.state = UPDATED and d.state.selectedHour not in d.visit.hour implies d.state.updateDay = none and d.state.updateHour = none and v in d.visit and v in f.visit and v.hour = v.dailyPlan.state.selectedHour and  v.status = SCHEDULED }

//If DailyPlan's State is CONFIRMED, associated Visit's Status is DONE
fact { all v: Visit | v.dailyPlan.state = CONFIRMED implies v.status = DONE and (v.dailyPlan.deviation != none or v.dailyPlan.deviation = none)}

//HELP REQUEST

//For each Agronomist the set of HelpResponse must be different
fact { all disj a1, a2: Agronomist | a1.helpResponse & a2.helpResponse = none }

//For each WellPerformingFarmer the set of HelpResponse must be different 
fact { all disj w1, w2: WellPerformingFarmer | w1.helpResponse & w2.helpResponse = none }

//For each responder the set of HelpResponse must be different 
fact { all w: WellPerformingFarmer, a: Agronomist | w.helpResponse & a.helpResponse = none }

//For each Farmer set of HelpRequest must be different
fact { all disj f1, f2: Farmer | f1.helpRequest & f2.helpRequest = none }

//For each HelpRequest the set of helpResponse must be different
fact {  all disj h1, h2: HelpRequest | h1.helpResponse & h2.helpResponse = none }

//Each HelpRequest is associated to a unique id
fact uniqueHelpRequest { all disj h1, h2: HelpRequest | h1.id != h2.id }

//A HelpResponse cannot exists without an associated HelpRequest
fact { all r: HelpResponse, h: HelpRequest| r.id = h.id implies r in h.helpResponse }

//Each HelpResponse must be related to the corresponding HelpRequest
fact { no r: HelpResponse | all h: HelpRequest | r.id != h.id }

//Two HelpResponse (or more) can be associated to the same HelpRequest
fact { some disj r1, r2: HelpResponse | r1.id = r2.id }

//Two HelpRequest (or more) can have the same questionner or state or wellPerformingFarmerAsRecipient
fact { some disj h1, h2: HelpRequest |  h1.questionner = h2.questionner or  h1.state = h2.state or h1.wellPerformingFarmerAsRecipient = h2.wellPerformingFarmerAsRecipient }

//Two HelpRequest (or more) have always the same Recipient if they have the same questionner and if they have the same wellPerformingFarmerAsRecipient
fact { all disj h1, h2: HelpRequest | h1.questionner = h2.questionner and h1.wellPerformingFarmerAsRecipient =h2.wellPerformingFarmerAsRecipient implies h1.recipient =  h2.recipient }

//Each HelpResponse belongs to the set of HelpResponse of the related responder 
fact { all  r: HelpResponse | r.responder.agronomist = none implies r in r.responder.wellPerformingFarmer.helpResponse }
fact { all  r: HelpResponse | r.responder.wellPerformingFarmer = none implies r in r.responder.agronomist.helpResponse }

//All HelpResponses are from Agronomist or WellPerformingFarmer
fact { all h: HelpRequest, r: HelpResponse | h.id = r.id implies r.responder.agronomist.helpResponse + r.responder.wellPerformingFarmer.helpResponse = h.helpResponse }

//HelpRequest has always responsible Agronomist as Recipient (the one belonging from the same Famer's Mandal)
fact { all h: HelpRequest | h.questionner.mandal.agronomist = h.recipient.agronomist }

//WellPerformingFarmer can be Recipient of HelpRequest only when wellPerformingFarmerAsRecipient is True
fact { 
all h: HelpRequest, w: WellPerformingFarmer | h.wellPerformingFarmerAsRecipient = True implies h.recipient.wellPerformingFarmer = w }

//Each HelpResponse can have exactly one responder 
fact { 
all h: HelpRequest, r: HelpResponse | one w: WellPerformingFarmer | r.id = h.id and h.wellPerformingFarmerAsRecipient = True implies (( r.responder.wellPerformingFarmer = w and r.responder.agronomist = none ) or (r.responder.agronomist = h.recipient.agronomist and r.responder.wellPerformingFarmer = none )) } 

//WellPerformingFarmer are not Recipient of HelpRequest when wellPerformingFarmerAsRecipient is False
fact { 
all h: HelpRequest, r: HelpResponse | r in h.helpResponse and h.wellPerformingFarmerAsRecipient = False implies h.recipient.wellPerformingFarmer = none and r.responder.wellPerformingFarmer = none and r.responder.agronomist = h.recipient.agronomist }

//If WellPerformingFarmer is not Recipient of a Help Request, only the Agronomist will reply though a Help Response
fact { 
all h: HelpRequest | h.recipient.wellPerformingFarmer = none implies h.helpResponse.responder.agronomist = h.recipient.agronomist  and h.helpResponse.responder.wellPerformingFarmer = none}

// If a HelpRequest exists it must be CREATED or SOLVED
fact { all h: HelpRequest | h.state = CREATED or h.state = SOLVED }

//A CREATED HelpRequest must be visible by the questionner (Farmer) in HelpRequest 
fact { all f: Farmer, h: HelpRequest | h.state = CREATED and h.questionner = f implies h in f.helpRequest }

//A SOLVED HelpRequest cannot be in HelpRequest (it cannot be visible by Farmer who solved it and it must be deleted with associated HelpResponse)
fact { all f: Farmer, h: HelpRequest | h.state = SOLVED and h.questionner = f implies h not in f.helpRequest and h = none }
