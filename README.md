Hi there! For our easyA hackathon project, we are building a prediction market for the weather. In particular, we are focused on a prediction market for the weather. Traders can bet wheather it will be above or below a particular temperature. Bet's are simple "Will the high temperature tomorrow in [X] be above or below 65 degrees?", and trader's can buy or sell YES or NO.

To price the odds, we simply state that the price of YES is the ratio of YES VOTES / (YES VOTES + NO VOTES). Thus as more people buy yes, this increases the number of votes on YES. The odds of winning are implied by the market as YES VOTES / (YES VOTES + NO VOTES).

To add a single yes vote, you can do this by betting 1 heat token. Betting the heat token will lock it into the contract and at finalization, you will be able withdraw your investment + the reward if you are the winner.


At the finalization, there is a 24 hour dispute window from which an arbitrator can arbitrate the outcome.

If no sucessful challenge is made, the full amount of heat tokens is allocated to the winners. You share of heat tokens is equal to You Votes on Winning Side x (Yes votes + No Votes) / (Votes on Winning Side)

You can then re-invest your heat tokens into new markets!
