//DISCUSSION FORUM

//G.9 Allow farmers to interact on the Discussion Forum

//Farmer opens a Thread
assert openAThread {
all t: Thread | one f: Farmer | t in f.thread }
check openAThread for 4

//Farmer replies to a Thread writing a Post
assert writeAPost {
no f: Farmer | one p: Post | p.responder = f and p not in f.post }
check writeAPost for 5

//Every Post is in exactly one Thread
assert oneLocation { 
all p: Post | one t: Thread | p in t.post }
check oneLocation for 5


//DAILYPLAN

//G.13 Allows agronomists to visualize their own Daily Plan to visit farms in the mandal

//Agronomist visualizes DailyPlan
assert visualizeDailyPlan {
all d: DailyPlan | ( one a: Agronomist | d in a.dailyPlan) }
check visualizeDailyPlan for 4

//Each DailyPlan is associated to exactly one Agronomist
assert oneAgronomist { 
all d: DailyPlan | one a: Agronomist | d in a.dailyPlan }
check oneAgronomist for 5

//Each Visit is in exactly one DailyPlan
assert oneDailyPlan { 
all v: Visit | one d: DailyPlan | v in d.visit }
check oneDailyPlan for 5

//Each Visit is associated to exactly one Farmer
assert oneFarmer { 
all v: Visit | one f: Farmer | v in f.visit }
check oneFarmer for 5

//G.14 Allows agronomists to manage their own Daily Plan

//Agronomist confirms DailyPlan specifying deviations if needed
assert confirmDailyPlanDev {
all d: DailyPlan | d.state = CONFIRMED implies ( one a: Agronomist | d in a.dailyPlan and (d.deviation != none or d.deviation = none)) }
check confirmDailyPlanDev for 4

//Agronomist updates the DailyPlan 
assert updateDailyPlan {
all d: DailyPlan | d.state = UPDATED implies ( one a: Agronomist | d in a.dailyPlan) }
check updateDailyPlan for 4

//Agronomist adds a new Visit in the DailyPlan
assert newVisit {
no d: DailyPlan | one v: Visit | d.state = UPDATED and d.state.selectedHour not in d.visit.hour and v.hour = d.state.selectedHour and v not in d.visit }
check newVisit for 4

//Agronomist updates a Visit in the DailyPlan
assert updateVisit {
no d: DailyPlan | one v: Visit | d.state = UPDATED and d.state.selectedHour in d.visit.hour and v.hour = d.state.updateHour and v.day = d.state.updateDay and v not in d.visit }
check updateVisit for 4


//HELPREQUEST

//G.8 Allows farmers to receive help from agronomist and other farmers through Help Requests

//Farmers makes a HelpRequest
assert makeHelpRequest {
all h: HelpRequest | h. state = CREATED implies ( one f: Farmer | h in f.helpRequest) }
check makeHelpRequest for 4

//Farmer makes HelpRequest with Agronomist as Recipient by default
assert agronomistByDefault {
no a : Agronomist | one h : HelpRequest | a = h.questionner.mandal.agronomist and a not in h.recipient.agronomist }
check agronomistByDefault for 4

//Farmer makes HelpRequest with WellPerformingFarmer as Recipient too
assert addRecipient {
no w : WellPerformingFarmer | one h : HelpRequest | h.wellPerformingFarmerAsRecipient = True and w not in h.recipient.wellPerformingFarmer }
check addRecipient for 4

//Agronomist replies to a HelpRequest
assert AgronomistHelpResponse {
no a: Agronomist | one r: HelpResponse | r.responder.agronomist = a and r not in a.helpResponse }
check AgronomistHelpResponse for 5

//WellPerformingFarmer replies to a HelpRequest
assert FarmerHelpResponse {
no w: WellPerformingFarmer | one r: HelpResponse | r.responder.wellPerformingFarmer = w and r not in w.helpResponse }
check FarmerHelpResponse for 5

//Each HelpResponse is in exactly one HelpRequest
assert oneLocationHelpResponse { 
all r: HelpResponse | one h: HelpRequest | r in h.helpResponse }
check oneLocationHelpResponse for 5

//Farmer solves a HelpRequest
assert solveHelpRequest {
all h: HelpRequest, r: HelpResponse | h. state = SOLVED and h.id = r.id implies ( no f : Farmer, a: Agronomist, w: WellPerformingFarmer | h in f.helpRequest or r in a.helpResponse or r in w.helpResponse) }
check solveHelpRequest for 4


















