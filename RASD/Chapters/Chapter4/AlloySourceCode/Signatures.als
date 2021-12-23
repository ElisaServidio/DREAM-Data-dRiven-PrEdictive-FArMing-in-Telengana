module util/boolean

abstract sig Bool {}
one sig True, False extends Bool {}

//A Mandal in Telangana
sig Mandal {
agronomist: one Agronomist,
farmer: some Farmer }

//A Farmer belonging to a certain Mandal
sig Farmer {
mandal: one Mandal,
helpRequest: set HelpRequest,
visit: some Visit, 
thread: set Thread,
post: set Post }

// There exists exactly one Discussion Forum 
one sig Forum { 
thread: set Thread }

// A Thread in the Discussion Forum
sig Thread { 
id: one Int,
questionner: one Farmer,
post : set Post } { id > 0 }

// A Post in a Thread
sig Post  { 
id: one Int,
responder: one Farmer } { id > 0 }

//An Agronomist responsible of a certain Mandal
sig Agronomist {
mandal: one Mandal,
helpResponse: set HelpResponse,
dailyPlan: some DailyPlan }

//A DailyPlan managed by a certain Agronomist
sig DailyPlan {
agronomist:one Agronomist,
day: one Day,
state: one DailyPlanState,
visit: some Visit,
deviation: lone Deviation }

sig Deviation { }

abstract sig DailyPlanState { }
//To avoid logical error due to the homonymy with HelpRequestState, DailyPlanState CREATED has been modified into GENERATED
one sig GENERATED extends DailyPlanState { }
one sig UPDATED extends DailyPlanState { 
selectedHour: one Hour,
updateHour: lone Hour,
updateDay: lone Day }
one sig CONFIRMED extends DailyPlanState { }

sig Day { }
sig Hour { }

//A Visit belonging to a certain DailyPlan
sig Visit {
day: one Day,
hour: one Hour,
farmer: one Farmer,
dailyPlan: one DailyPlan,
status: one Status}

abstract sig Status { }

one sig SCHEDULED extends Status { }
one sig DONE extends Status { }

//A Farmer who can reply to a HelpRequest if indicated as recipient
sig WellPerformingFarmer { 
helpResponse: set HelpResponse }

//A HelpRequest made by a Farmer
sig HelpRequest {
id: one Int,
questionner: one Farmer,
state: one HelpRequestState,
recipient: one Recipient,
wellPerformingFarmerAsRecipient: one Bool,
helpResponse:some HelpResponse } { id > 0 }

abstract sig HelpRequestState { }

one sig CREATED, SOLVED extends HelpRequestState { }

//A Recipient of a HelpRequest
sig Recipient { 
agronomist: one Agronomist,
wellPerformingFarmer: set WellPerformingFarmer }

//A HelpResponse to a HelpRequest
sig HelpResponse {
id: one Int,
responder: one Responder } { id > 0 }

//A Responder of a HelpResponse
sig Responder {
agronomist: lone Agronomist,
wellPerformingFarmer: lone WellPerformingFarmer}
