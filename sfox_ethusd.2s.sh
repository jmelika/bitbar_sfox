#!/bin/bash
export PATH='/usr/local/bin:/usr/bin:$PATH'

# Shows (Ask, Bid, Mid, High, Low, Volume and Timestamp from Bitfinex REST API Ticker BTCUSD 
#
# <bitbar.title>SFOX ARB BTCUSD plugin</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Joseph Melika</bitbar.author>
# <bitbar.author.github>jmelika</bitbar.author.github>
# <bitbar.desc>Shows (Ask, Bid and ARB/SPREAD) </bitbar.desc>
# <bitbar.image></bitbar.image>
#
# by Joseph Melika

SFOX_FEE="0.007"

DELTA=$(curl -s "https://api.sfox.com/v1/markets/orderbook/ethusd" | jq -r '[.asks[0] | .[0]], .bids[0] | .[0]')

# Let's get some useful values from here
USD_ASK=`echo $DELTA | awk -F" " '{print $1}'`
USD_BID=`echo $DELTA | awk -F" " '{print $2}'`
SFOX_FEE_USD=$(echo "${USD_ASK} * ${SFOX_FEE}" | bc)
SPREAD_ARB=$(echo "${USD_ASK} - ${USD_BID} + ${SFOX_FEE_USD}" | bc)


# I need to make the Arb pop, so let's put some colors
case "$SPREAD_ARB" in
-*)
    echo "ETH-USD A $SPREAD_ARB | color=red"
    ;;
*)
    echo "ETH-USD S $SPREAD_ARB"
    ;;
esac

#Let's display the data
echo "---"
echo "Ask: " $USD_ASK
echo "Bid: " $USD_BID
echo $SPREAD_ARB
echo "---"
