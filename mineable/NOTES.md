# Notes

From the Mineable Punk F.A.Q - <https://www.mpunks.org/faq>


Q: What is this?

mpunks are generated using cryptopunk assets, all on-chain.

mpunks cannot be claimed; they must be mined. A valid 256-bit hash can be fed through an on-chain minting function that 
uses the probability distribution and assets of the original 10,000 cryptopunks to generate an mpunk.


Q: Why is my nonce invalid/why did my Mint transaction revert?

there are two common reasons why a nonce is invalid or why a Mint transaction could revert. 
One reason is that someone else mined an mpunk before your Mint transaction was confirmed. 
Another is that you waited too long (a few minutes is too long) to send the transaction after finding a valid nonce.


Difficulty increases

difficulty increases follow a schedule determined by an immutable configuration contract 
called "OtherPunksConfiguration" (our original name). 
you can see this in the contract source code. the schedule is as follows:


0-99 = easy. should take a 2017 macbook pro no more than a few minutes to mine a punk.

100-499 = a bit harder. should take a 2017 macbook pro 1 hour to mine a punk.

500-1999 = dramatic increase. browser-based mining is impractical. should take 100 RTX 3080's 1 hour to mine a punk.

2000-2999 = should take 500 RTX 3080's 1 hour to mine a punk.

3000-3999 = should take 1,000 RTX 3080's 1 hour to mine a punk.

4000-5999 = should take 3,000 RTX 3080's 1 hour to mine a punk.

6000-9999 = should take 10,000 RTX 3080's 1 hour to mine a punk.

10000+ = possible but almost infeasible. should take the entire ethereum network hash rate 1 year to mine a punk.



Q: What about the original cryptopunks?

while it is technically possible for an original cryptopunk to be mined, 
this application prevents you from mining one of the original cryptopunks. 
if someone were to create their own miner and mine an original cryptopunk, 
the mpunks contract allows for the burning of any mined original cryptopunks, 
or the blockage of any specific original cryptopunk from being mined, through the following functions:

- burnMinedOriginalPunkId
- blockUnminedOriginalPunkId

anyone can call these functions.



Q: How can I get an mpunk?

mpunks are created by miners, who work to discover valid numbers that in turn generate mpunks. 
you can buy an mpunk from opensea, or become a miner!



Q: How many mpunks are there?

while there are technically millions of mpunks, 
the number of mpunks is practically only 10,000 based on where modern day GPU's are at.

we encountered an issue on our initial launch and subsequently transferred the ownership of mpunks 
from the original contracts to the current contract (you can see this in the source code). 
more are generated over time through mining, with a practical cap of 10,000. 
mining difficulty increases as more punks are mined. 
after 10,000 mpunks are mined, mining becomes extremely difficult; with modern hardware, 
it would take the entire ethereum mining network a year to mine mpunk #10001.



Q: How does mining work?

the mpunks contract stores an 88-bit integer called a "Difficulty Target".

to mint mpunks, miners submit an 88-bit integer, called a "nonce", to the contract's Mint function. 
the nonce is then hashed with the miner's address, as well as the assets of the most recently mined punk, 
to produce a 256-bit integer called a "seed".

the last 88 bits of the seed are then compared to the Difficulty Target. 
if the last 88 bits are less than the Difficulty Target, the submitted nonce is considered valid, 
and an mpunk is generated from the 256-bit seed.

the app auto suggests a high gas limit. gas cost is dynamic based on punk rarity. 
minting should cost around 400,000 gas on average. however, every 33rd punk spawns an extra punk for founders. 
this brings the worst case gas cost to 1,400,000.



Q: How are mpunks stored?

the mpunks contract stores a mapping between mpunk Token ID's, and their respective assets. 
a punk's assets are represented by a 96 bit integer. 
this integer consists of 12 8-bit chunks. each 8-bit chunk corresponds to an attribute slot 
(eg. head, eyes, mouth, beard). the value of an 8-Bit chunk maps to an asset ID, stored in the PublicCryptopunksData contract. 
the render function of PublicCryptopunksData then layers these assets on top of one another to produce a punk's image.



Q: How are founders rewarded?

every 33rd mint will mint an additional punk that is sent to the contract owner. 
this will essentially double the gas cost of every 33rd mint.

the seed for this additional punk is obtained by hashing the seed of the most recent 33rd punk. 
(This is essentially a double hash, since the seed of the prior punk is itself a hash).

