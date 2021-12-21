//DISCUSSION FORUM

//Simulation that shows a set of Thread and related Post
pred world0 {
#Thread > 3
#Post > 3
}
run world0 for 7

//DAILY PLAN

//Simulation that shows set of Visit belonging to different DailyPlan with different State
pred world1 {
#DailyPlan > 0
#Visit > 0
one d: DailyPlan | d.state = GENERATED
one d: DailyPlan | d.state = UPDATED
one d: DailyPlan | d.state = CONFIRMED and d.deviation != none
one d: DailyPlan | d.state = CONFIRMED and d.deviation = none
}
run world1 for 5

//HELP REQUEST

//Simulation that shows a set of Help Request with both Agronomist and WellPerformingFarmers as Recipient
pred world2 {
#HelpRequest > 0
#HelpResponse > 0
#Farmer > 0
#WellPerformingFarmer > 0
#Agronomist > 0
one h: HelpRequest | h.wellPerformingFarmerAsRecipient = False
one h: HelpRequest | h.wellPerformingFarmerAsRecipient = True
}
run world2 for 5
