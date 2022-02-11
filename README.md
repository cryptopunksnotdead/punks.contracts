Crypto Collectibles Series -
[Cats](https://github.com/cryptocopycats/contracts) ·
[Punks](https://github.com/cryptopunksnotdead/contracts)


# CryptoPunks Blockchain Contracts / Services

_Code on the Blockchain - Electronic Contract Scripts_



## Timeline

_Punk Contracts by Creation Date_

**2017**

June 9, 2017 (Block #3842489) - **/punks-v1** - CryptoPunks Classic V1 - "First Deploy"

June 22, 2017 (Block #3914495) - **/punks-v2** - CryptoPunksMarket


**2020**

September 8, 2020 (Block #10821737) - **/punks-v2-wrapped** - Wrapped Punks (WPUNKS)


**2021**

March 25, 2021 (Block #12105923) - **/punks-v1-wrapped-i** - Wrapped Punks V1 (WPUNKS1), "Classic Edition"


June 14, 2021 (Block #12630376) - **/phunks** - CryptoPhunks (PHUNKS)

June 21, 2021 (Block #12674389) - **/phunks** - CryptoPhunksV2 (PHUNKS)

June 29, 2021 (Block #12731429) - **/hdpunks** - HD Punks (HDPUNKS)

August 7, 2021 (Block #12975638) - **/zunks** - Zunks (ZUNK)

August 7, 2021 (Block #12979903)  - **/bored** - BoredPunkYachtClub (BPYC)

August 15, 2021  (Block #13026517) - **/expansion-i** - ExpansionPunks (XPUNKS)

August 18, 2021 (Block #13045935) - **/punksdata** - CryptoPunksData Update / Add-On / Service

August 27, 2021 (Block #13107807) - **/international** - InternationalPunks (INTPUNKS)

September 1, 2021 (Block #13138993) - **/ape** - ApePunks (APEK)

September 13, 2021 (Block #13214597) - **/other** - OtherPunks (OPUNKS)

September 21, 2021 (Block #13268745) - **/currency** - CurrencyPunks (CUPU)

September 23, 2021 (Block #13283328) - **/mineable** - MineablePunks (MPUNKS)

October 2, 2021 (Block #13339194) - **/society** - LostPunkSociety (LPS)

December 16, 2021 (Block #13817852) - **/phunks-v2-market** -  CryptoPhunksMarket

December 30, 2021 (Block #13906069) - **/expansion-ii** - ExpansionPhunks (PHUNX)



**2022**

January 17, 2022 (Block #14022431) - **/punks-v1-wrapped-ii** - Wrapped Cryptopunks V1 (WPV1)

January 24, 2022 (Block #14066948) - **/punks-v1-market** - PunksMarket

February 2, 2022 (Block #14127834) - **/punks-v3** -  Cryptopunks V3 (V3PUNK)

February 3, 2022 (Block #14132029) - **/phunks-v3** - Phunks V3 (V3PHNKS)

February 4, 2022 (Block #14138557) - **/punks-v4** - Cryptopunks V4 (V4PUNK)


February 5, 2022 (Block #14142987)  - **/phunks-v1-wrapped** - Wrapped Cryptophunks V1 (WPHV1)



## Historic V1  - "First Deploy"

> When CryptoPunks launched, the contract was exploitable.
> Sellers didn't get paid. LarvaLabs quickly launched a fixed version
> of the contract, which everyone uses.
>
> But the V1 tokens are still out there.

<!--
https://twitter.com/seeker_curious/status/1375112685746941955
https://twitter.com/seeker_curious/status/1374605517444706306
-->

### /punks-v1 - CryptoPunks

Etherscan

- CryptoPunks, see contract address [`0x6Ba6f2207e343923BA692e5Cae646Fb0F566DB8D`](https://etherscan.io/address/0x6Ba6f2207e343923BA692e5Cae646Fb0F566DB8D#code), June 9, 2017 12:22:50 AM (Block #3842489)


### /punks-v1-wrapped-i - Wrapped Punks V1 (WPUNKS1)

Etherscan

- PunksV1Wrapper (WPUNKS1), see contract address [`0xf4a4644e818c2843ba0aabea93af6c80b5984114`](https://etherscan.io/address/0xf4a4644e818c2843ba0aabea93af6c80b5984114#code), March 25, 2021 04:26:43 AM (Block #12105923)


### /punks-v1-wrapped-ii - Wrapped Punks V1 (WPV1)

Etherscan

- PunksV1Wrapper (WPV1), see contract address [`0x282bdd42f4eb70e7a9d9f40c8fea0825b7f68c5d`](https://etherscan.io/address/0x282bdd42f4eb70e7a9d9f40c8fea0825b7f68c5d#code), January 17, 2022 10:15:07 AM (Block #14022431)


### /punks-v1-market -  PunksMarket


Etherscan

- PunksMarket, see contract address [`0x759c6c1923910930c18ef490b3c3dbeff24003ce`](https://etherscan.io/address/0x0x759c6c1923910930c18ef490b3c3dbeff24003ce#code),
January 24, 2022 07:23:43 AM  (Block #14066948)




## Classic V2

### /punks-v2 - CryptoPunksMarket

Etherscan

- CryptoPunkMarket, see contract address [`0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb`](https://etherscan.io/address/0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb#code), June 22, 2017 07:40:00 PM (Block #3914495)


For more see [**Inside the CryptoPunksMarket Blockchain Contract / Service »**](punks-v2)


### /punksdata  - CryptoPunksData Update / Add-On / Service

> On-chain Cryptopunk images and attributes, by Larva Labs.
>
> This contract holds the image and attribute data for the Cryptopunks
>  on-chain.
> The Cryptopunk images are available as raw RGBA pixels,
> or in SVG format.
> The punk attributes are available as a comma-separated list.
> Included in the attribute list is the head type
> (various color male and female heads,
> plus the rare zombie, ape, and alien types).

Etherscan

- CryptoPunksData, see contract address [`0x16f5a35647d6f03d5d3da7b35409d65ba03af3b2`](https://etherscan.io/address/0x16f5a35647d6f03d5d3da7b35409d65ba03af3b2#code),
August 18, 2021 12:10:24 AM (Block #13045935)



Note:  If you are looking for the on-chain data (attributes or the pixel matrix / bitmap and so on) - the data is NOT in the contract source
but in the 266 transaction (txn) inputs.   See [punksdata/transactions.txt](punksdata/transactions.txt).






### /punks-v2-wrapped - Wrapped Punks (WPUNKS)

Etherscan

- WrappedPunk (WPUNKS), see contract address [`0xb7f7f6c52f2e2fdb1963eab30438024864c313f6`](https://etherscan.io/address/0xb7f7f6c52f2e2fdb1963eab30438024864c313f6#code), September 8, 2020 03:11:25 PM (Block #10821737)


For more see [**Inside the Wrapped Punk (WPUNKS) Blockchain Contract / Service »**](punks-v2-wrapped)





## V3, V4, V5, V6, ...

### /punks-v3 - Cryptopunks V3 (V3PUNK)

Etherscan

- Cryptopunks V3 (V3PUNK), see contract address [`0xD33c078C2486B7Be0F7B4DDa9B14F35163B949e0`](https://etherscan.io/address/0xD33c078C2486B7Be0F7B4DDa9B14F35163B949e0#code), February 2, 2022 04:57:59 PM (Block #14127834)



### /punks-v4 - Cryptopunks V4 (V4PUNK)

Etherscan

- Cryptopunks V4 (V4PUNK), see contract address [`0xd12882c8b5d1bccca57c994c6af7d96355590dbd`](https://etherscan.io/address/0xd12882c8b5d1bccca57c994c6af7d96355590dbd#code), February 4, 2022 08:57:46 AM  (Block #14138557)





## More

### /phunks (v1 & v2) - CryptoPhunks (PHUNKS)

Etherscan

- CryptoPhunks (PHUNKS), see contract address [`0xa82f3a61f002f83eba7d184c50bb2a8b359ca1ce`](https://etherscan.io/address/0xa82f3a61f002f83eba7d184c50bb2a8b359ca1ce#code), June 14, 2021 04:18:53 AM (Block #12630376)

- CryptoPhunksV2 (PHUNKS), see contract address [`0xf07468ead8cf26c752c676e43c814fee9c8cf402`](https://etherscan.io/address/0xf07468ead8cf26c752c676e43c814fee9c8cf402#code), June 21, 2021 12:07:08 AM (Block #12674389)


### /phunks-v1-wrapped - Wrapped Cryptophunks V1 (WPHV1)


> Q: Why wrapped?
>
> A: Cryptophunks V1 are buggy. Philip (the intern) is every image.
>
> Q: How do you wrap a Phunk V1?
>
> A: You send your Phunk V1 to
>  `0x235d49774139c218034c0571ba8f717773edd923` with `safeTransferFrom()`
>  and the wrapping occurs in the `onERC721Received()` callback!

Etherscan

- Wrapped Cryptophunks V1 (WPHV1), see contract address
[`0x235d49774139c218034c0571ba8f717773edd923`](https://etherscan.io/address/0x235d49774139c218034c0571ba8f717773edd923#code), February 5, 2022 01:04:58 AM (Block #14142987)



### /phunks-v2-market - CryptoPhunksMarket

Etherscan

- CryptoPhunksMarket, see contract address [`0xd6c037bE7FA60587e174db7A6710f7635d2971e7`](https://etherscan.io/address/0xd6c037bE7FA60587e174db7A6710f7635d2971e7#code), December 16, 2021 06:40:01 PM (Block #13817852)


### /phunks-v3 - Phunks V3 (V3PHNKS)

Etherscan

- Phunks V3 (V3PHNKS), see contract address [`0xA19f0378A6F3f3361d8e962F3589Ec28f4f8F159`](https://etherscan.io/address/0xA19f0378A6F3f3361d8e962F3589Ec28f4f8F159#code), February 3, 2022 08:49:52 AM (Block #14132029)






### /hdpunks - HD Punks (HDPUNKS)

Etherscan

- HDPunks (HDPUNKS), see contract address [`0x3e86e26915403ae0e1cff7e7b23377b3a30104a0`](https://etherscan.io/address/0x3e86e26915403ae0e1cff7e7b23377b3a30104a0#code), June 29, 2021 09:52:03 PM (Block #12731429)





### /zunks -  Zunks (ZUNK)

web: [cryptozunks.com](https://www.cryptozunks.com)

> CryptoPunks were the first 10,000. CryptoZunks are the last 10,000.
>
> Numbered 10,000 - 19,999, Zunks are the first Punks to be
> generated on-chain with randomized attributes.
> Spin to mint your base model Zunk and re-roll any attributes.
>
>
>  How does on-chain generation for Zunks work? How do we keep Zunks unique from existing Punks?
>
> 1) CryptoZunks is the first on-chain Punks derivative project where the smart contract generates all the attributes randomly on-chain when the user mints. How does this work?
>
> 2) After determining what attributes the Zunk has, we create a string representation of the Zunk which can be decoded into the various attributes (gender, hat, beard, etc.).
>
> 3) This string representation of the Zunk is then saved on the blockchain. On subsequent Zunk mints, the contract validates that it hasn't generated a same Zunk that already exists. If it has, the contract will re-generate random attributes until it has created a unique Zunk.
>
> 4) There are optimizations built into the contract to re-generate a Zunk as few times as possible. It's important that users aren't stuck endlessly generating invalid Zunks and to keep gas usage low.
>
> 5) We've run thousands of simulations and have validated that we can reliably generate 10k unique Zunks Partying face
>
> 6) We also wanted to guarantee that the generated Zunk doesn't match an existing Punk. We took all 10k Punks, converted them into our string representation, and seeded the contract with these Punks so that the contract may validate against them.
>
> 7) Now when the contract generates a Zunk or a user rerolls an attribute, the contract will validate that it does not match any existing Zunks or Punks. After the Zunk is confirmed to be unique and minted, the contract emits an event of the string representation of the Zunk.
>
> 8) Our goal is to innovate and to bring a unique and fun minting experience that gives some power to the user, while still upholding the ethos of decentralization. Every Zunk is randomly generated on chain, your Zunk's destiny is in your hands!
>
> -- [Amanda](https://twitter.com/0xMandy/status/1423678586494410754)
>
>
> All 10,000 Zunks have been minted!
> A lot of dizziness from all of the spins today.
>
> -- [CryptoZunks](https://twitter.com/CryptoZunks/status/1424165997733289992), Aug 8, 2021
>
>
> Commentary:
> The devs are raking in at least $1.35 million dollars
> with the mint of 10,000 Zunks
> and will of course profit a
> substantial amount of all future sales.


Etherscan

- CryptoZunks (ZUNK), see contract address [`0x031920cc2d9f5c10b444fd44009cd64f829e7be2`](https://etherscan.io/address/0x031920cc2d9f5c10b444fd44009cd64f829e7be2#code), August 7, 2021 04:01:17 AM (Block #12975638)


### /bored - BoredPunkYachtClub (BPYC)

Etherscan

- BoredPunkYachtClub (BPYC), see contract address [`0x488a85d21ac95c9bb0cdaa0d2bfa427fcea88d1e`](https://etherscan.io/address/0x488a85d21ac95c9bb0cdaa0d2bfa427fcea88d1e#code),
August 7, 2021 07:38:45 PM (Block #12979903)



### /expansion-i  -  ExpansionPunks (XPUNKS)

Etherscan

- ExpansionPunks (XPUNKS), see contract address [`0x0d0167a823c6619d430b1a96ad85b888bcf97c37`](https://etherscan.io/address/0x0d0167a823c6619d430b1a96ad85b888bcf97c37#code),
August 15, 2021 12:13:20 AM  (Block #13026517)



### /expansion-ii  -  ExpansionPhunks (PHUNX)

Etherscan

- ExpansionPhunks (PHUNX), see contract address [`0x71eb5c179ceb640160853144cbb8df5bd24ab5cc`](https://etherscan.io/address/0x71eb5c179ceb640160853144cbb8df5bd24ab5cc#code), December 30, 2021 10:14:39 AM  (Block #13906069)



### /international - InternationalPunks (INTPUNKS)

Etherscan

- InternationalPunks (INTPUNKS), see contract address [`0x7b89c26ff23be91695bdafb2fc80ab919f2d2a4e`](https://etherscan.io/address/0x7b89c26ff23be91695bdafb2fc80ab919f2d2a4e#code),
August 27, 2021 01:59:04 PM  (Block #13107807)



### /ape - ApePunks (APEK)

Etherscan

- ApePunks (APEK), see contract address [`0x97f2eed9a7d3edbbca56120ed26795a5467f57fc`](https://etherscan.io/address/0x97f2eed9a7d3edbbca56120ed26795a5467f57fc#code),
September 1, 2021 09:34:09 AM (Block #13138993)


### /other - OtherPunks (OPUNKS)

Etherscan

- OtherPunks (OPUNKS), see contract address [`0x1a9b1bb73ed02db2dc3cd0d25adb42ad4d06389f`](https://etherscan.io/address/0x1a9b1bb73ed02db2dc3cd0d25adb42ad4d06389f#code),
September 13, 2021 01:58:38 AM (Block #13214597)



### /currency - CurrencyPunks (CUPU)

Etherscan

- CurrencyPunks (CUPU), see contract address [`0xe433e90c5b898819544346e73a501d9e8013dbd8`](https://etherscan.io/address/0xe433e90c5b898819544346e73a501d9e8013dbd8#code),
September 21, 2021 11:04:00 AM (Block #13268745)



### /mineable - MineablePunks (MPUNKS)

> Mineable punks are generated using cryptopunk assets, all on-chain.
> Mineable punks cannot be claimed; they must be mined. A valid 256-bit hash can be fed through
> an on-chain minting function that uses the probability distribution and assets of the original 10,000 cryptopunks
> to generate an mineable punk.


Etherscan

- MineablePunks (MPUNKS), see contract address [`0x595a8974c1473717c4b5d456350cd594d9bda687`](https://etherscan.io/address/0x595a8974c1473717c4b5d456350cd594d9bda687#code),
September 23, 2021 05:31:33 PM (Block #13283328)



### /society - LostPunkSociety (LPS)

> It's a boy! Lost Punk #10012 was minted as the child of crypto punk #1340
> and lost punk #10005.
>
> It's a girl! Lost Punk #10011 was minted by as the child of
> crypto punks #7822 and #9271.
>
>  o o o
>
> If you own both a male and a female crypto punk,
> you can mint two children for free,
> and it's all happening 100% on-chain.
>
> Note: You only need real crypto punks to mint the first generation.
> The next generation punks could become a cheaper entry point
> when supply gets large enough.
>
> Every time a lost punk child is minted, it can be used to mint more children.
> Parents can be two crypto punks, two lost punks, or a mix of both,
> and you can use parents from different generations to mint.
>
> The cost of minting does increase linearly by 0.05 ETH
> per generation to avoid flooding supply
> and every parent can have max two children
> and you cannot mint from parents that are closely related,
> so we are unlikely to see thousands of lost punks soon...



Etherscan

- LostPunkSociety (LPS), see contract address [`0xa583beacdf3ed3808402f8db4f6628a7e1c6cec6`](https://etherscan.io/address/0xa583beacdf3ed3808402f8db4f6628a7e1c6cec6#code),
October 2, 2021 09:57:19 AM (Block #13339194)



## Questions? Comments?

Post them on the [CryptoPunksDev reddit](https://old.reddit.com/r/CryptoPunksDev). Thanks.
