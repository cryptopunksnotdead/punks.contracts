pragma solidity 0.8.0;

import "@openzeppelin/contracts@v4.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@v4.3/access/Ownable.sol";
import "@openzeppelin/contracts@v4.3/utils/Strings.sol";


contract LostPunkSociety is ERC721Enumerable, Ownable {
    CryptoPunksAssets private cryptoPunksAssets;
    CryptoPunksData private cryptoPunksData;
    CryptoPunksMarket private cryptoPunksMarket;

    uint16 private constant cryptoPunksCount = 10000;
    uint16 private punksCount = 10000;
    uint16 private TOTAL_CAP;
    uint8 private GENERATION_CAP;
    uint256 private SEED;
    uint256 private TIER_PRICE_IN_WEI;

    mapping(uint16 => bytes) private punks;
    mapping(uint16 => uint16) private fatherMapping;
    mapping(uint16 => uint16) private motherMapping;
    mapping(uint16 => uint16) private generationMapping;
    mapping(uint16 => uint16) private child1Mapping;
    mapping(uint16 => uint16) private child2Mapping;

    bool private shouldVerifyCryptoPunkOwnership;
    bool private shouldVerifyLostPunkOwnership;
    bool private freeMintForCryptoPunks;
    bool private contractSealed;

    modifier unsealed() {
        require(!contractSealed, "Contract sealed.");
        _;
    }

    function sealContract() external onlyOwner unsealed {
        contractSealed = true;
    }

    function destroy() external onlyOwner unsealed {
        selfdestruct(payable(owner()));
    }

    function configureEnvironment(
        address cryptoPunksAssetsAddress,
        address cryptoPunksDataAddress,
        address cryptoPunksMarketAddress,
        uint8 generationCap,
        uint16 totalCap,
        uint256 tierPriceInWei,
        bool freeForCryptoPunks,
        bool shouldVerifyCryptoPunk,
        bool shouldVerifyLostPunk) public onlyOwner unsealed {
        cryptoPunksAssets = CryptoPunksAssets(cryptoPunksAssetsAddress);
        cryptoPunksData = CryptoPunksData(cryptoPunksDataAddress);
        cryptoPunksMarket = CryptoPunksMarket(cryptoPunksMarketAddress);
        GENERATION_CAP = generationCap;
        TOTAL_CAP = totalCap;
        TIER_PRICE_IN_WEI = tierPriceInWei;
        freeMintForCryptoPunks = freeForCryptoPunks;
        shouldVerifyCryptoPunkOwnership = shouldVerifyCryptoPunk;
        shouldVerifyLostPunkOwnership = shouldVerifyLostPunk;
    }

    constructor() ERC721("LostPunkSociety", "LPS") {
        configureEnvironment(
            0x2A256814597B4e3BE62ac0e599Bee9D7bED8C3cf,
            0x16F5A35647D6F03D5D3da7b35409D65ba03aF3B2,
            0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB,
            9,
            20000,
            (5 ether) / 100,
            true,
            true,
            true);
    }

    address private constant giveDirectlyDonationAddress = 0xc7464dbcA260A8faF033460622B23467Df5AEA42;

    function withdraw() external onlyOwner {
        uint256 donation = address(this).balance / 10;
        payable(giveDirectlyDonationAddress).transfer(donation);
        payable(owner()).transfer(address(this).balance);
    }

    function composite(bytes1 index, bytes1 yr, bytes1 yg, bytes1 yb, bytes1 ya) internal view returns (bytes4) {
        return cryptoPunksAssets.composite(index, yr, yg, yb, ya);
    }

    function getAsset(uint8 index) internal view returns (bytes memory) {
        return cryptoPunksAssets.getAsset(index);
    }

    function getAssetName(uint8 index) internal view returns (string memory) {
        return cryptoPunksAssets.getAssetName(index);
    }

    function getAssetType(uint8 index) internal view returns (uint8) {
        return cryptoPunksAssets.getAssetType(index);
    }

    function getAssetIndex(string memory text, bool isMale) internal view returns (uint8) {
        return cryptoPunksAssets.getAssetIndex(text, isMale);
    }

    function getMappedAsset(uint8 index, bool toMale) internal view returns (uint8) {
        return cryptoPunksAssets.getMappedAsset(index, toMale);
    }

    function nextPseudoRandom(uint256 max) internal returns (uint) {
        SEED = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, SEED)));
        return SEED % max;
    }

    struct TraitInfo {
        uint8 punkType;
        bool isMale;
        bool isDifferent;
        uint8 assetIndex;
        uint8 earringIndex;
        uint8 cigaretteIndex;
    }

    function breedPunkAssets(uint16 fatherIndex, uint16 motherIndex) internal returns (bytes memory childAssets) {
        require(fatherIndex >= 0 && fatherIndex < punksCount, "Unknown father");
        require(motherIndex >= 0 && motherIndex < punksCount, "Unknown mother");
        bytes memory fatherAssets = getPunkAssets(fatherIndex);
        bytes memory motherAssets = getPunkAssets(motherIndex);

        TraitInfo memory info;
        uint8 fa = uint8(fatherAssets[0]);
        uint8 ma = uint8(motherAssets[0]);
        if ((fa == 10) || (fa == 11)) { // alien or ape
            require((ma == fa) && (fatherIndex != motherIndex));
            info.isMale = true;
            info.punkType = fa;
        } else if (fa == 9) { // zombie
            require(ma >= 5 && ma < 9);
            info.isMale = true;
            info.punkType = fa;
        } else {
            require(fa >= 1 && fa < 5);
            require(ma >= 5 && ma < 9);
            info.isMale = nextPseudoRandom(2) == 0;
            uint8 low = (ma - 5) < (fa - 1) ? (ma - 5) : (fa - 1);
            uint8 high = (ma - 5) < (fa - 1) ? (fa - 1) : (ma - 5);
            info.punkType = (info.isMale ? 1 : 5) + uint8(low + nextPseudoRandom(high + 1 - low));
        }

        childAssets = new bytes(8);
        childAssets[info.assetIndex++] = bytes1(info.punkType);
        info.isDifferent = info.punkType != (info.isMale ? fa : ma);

        uint8[10] memory fatherTraits;
        uint8[10] memory motherTraits;
        for (uint8 j = 1; j < 8; ++j) {
            fa = uint8(fatherAssets[j]);
            fatherTraits[getAssetType(fa)] = fa;
            ma = uint8(motherAssets[j]);
            motherTraits[getAssetType(ma)] = ma;
        }

        for (uint8 j = 1; j < 10 && info.assetIndex < 8; ++j) {
            fa = info.isMale ? motherTraits[j] : fatherTraits[j]; // other parent trait
            ma = info.isMale ? fatherTraits[j] : motherTraits[j]; // same parent trait
            uint8 value = fa > 0 ? getMappedAsset(fa, info.isMale) : 0;
            if ((ma != 0) && ((value == 0) || (nextPseudoRandom(2) == 0))) {
                value = ma;
            }
            if (value != ma) {
                info.isDifferent = true;
            } else if ((value == 61) || (value == 125)) {
                info.earringIndex = info.assetIndex;
            } else if ((value == 19) || (value == 115)) {
                info.cigaretteIndex = info.assetIndex;
            }
            if (value > 0) {
                childAssets[info.assetIndex++] = bytes1(value);
            }
        }

        if (!info.isDifferent) {
            if (info.cigaretteIndex > 0) {
                for (uint8 j = info.cigaretteIndex; j < 8; ++j) {
                    childAssets[j] = j < 7 ? childAssets[j+1] : bytes1(0);
                }
            } else if (info.earringIndex > 0) {
                for (uint8 j = info.earringIndex; j < 8; ++j) {
                    childAssets[j] = j < 7 ? childAssets[j+1] : bytes1(0);
                }
            } else if (info.assetIndex < 7) {
                if (nextPseudoRandom(2) == 0) {
                    childAssets[info.assetIndex++] = bytes1(info.isMale ? 61 : 125);
                } else {
                    childAssets[info.assetIndex++] = bytes1(info.isMale ? 19 : 115);
                }
            }
        }
    }

    function verifyPunkOwnership(uint16 index) internal view {
        if (index < cryptoPunksCount) {
            require(!shouldVerifyCryptoPunkOwnership || (cryptoPunksMarket.punkIndexToAddress(index) == msg.sender), "Does not own this CryptoPunk.");
        } else {
            require(!shouldVerifyLostPunkOwnership || (ownerOf(index) == msg.sender), "Does not own this Lost Punk.");
        }
    }

    function mintLostPunk(uint16 fatherIndex, uint16 motherIndex) external payable {
        require(fatherIndex >= 0 && fatherIndex < punksCount);
        require(motherIndex >= 0 && motherIndex < punksCount);
        require(punksCount < TOTAL_CAP, "Total cap reached");
        require(child2Mapping[fatherIndex] == 0, "Previously minted children for father");
        require(child2Mapping[motherIndex] == 0, "Previously minted children for mother");

        uint16 fm = motherMapping[fatherIndex];
        uint16 mf = fatherMapping[motherIndex];
        require(
            ((fm == 0) || ((fm != motherMapping[motherIndex]) && (fm != motherIndex))) &&
            ((mf == 0) || ((mf != fatherMapping[fatherIndex]) && (mf != fatherIndex))),
            "Cannot mint children for close family");

        uint16 fatherGen = generationMapping[fatherIndex];
        uint16 motherGen = generationMapping[motherIndex];
        uint16 childGen = fatherGen > motherGen ? fatherGen + 1 : motherGen + 1;
        uint16 tier = freeMintForCryptoPunks ? childGen - 1 : childGen;

        require(childGen < GENERATION_CAP, "Generation cap reached");
        require(tier * TIER_PRICE_IN_WEI  <= msg.value, "Insufficient Ether sent");

        verifyPunkOwnership(fatherIndex);
        verifyPunkOwnership(motherIndex);

        uint16 childIndex = punksCount;
        punks[punksCount++] = breedPunkAssets(fatherIndex, motherIndex);
        fatherMapping[childIndex] = fatherIndex;
        motherMapping[childIndex] = motherIndex;
        generationMapping[childIndex] = childGen;

        if (child1Mapping[fatherIndex] == 0) {
            child1Mapping[fatherIndex] = childIndex;
        } else {
            child2Mapping[fatherIndex] = childIndex;
        }
        if (child1Mapping[motherIndex] == 0) {
            child1Mapping[motherIndex] = childIndex;
        } else {
            child2Mapping[motherIndex] = childIndex;
        }

        _mint(msg.sender, childIndex);
    }

    function tokenURI(uint256 index) public view override returns (string memory)
    {
        require(_exists(index));

        uint16 punkIndex = uint16(index);
        bytes memory punkAssets = getPunkAssets(uint16(punkIndex));

        string memory json = base64Encode(bytes(string(abi.encodePacked(
            '{"name": "Lost Punk #',
            Strings.toString(index),
            '", "description": "Lost Punks are descendants of the original CryptoPunks. Children can be minted from mother and father (max 2 children per parent). All metadata and images are fully generated and stored on-chain (10% donated to GiveDirectly.org). Inspired by LarvaLabs (not affiliated).", "image": "data:image/svg+xml;base64,',
            base64Encode(bytes(punkAssetsImageSvg(punkAssets, punkIndex))),
            '", "attributes": [',
            metadataAttributes(punkAssets, punkIndex),
            ']}'))));

        return string(abi.encodePacked('data:application/json;base64,', json));
    }


    function getPunkAssets(uint16 index) internal view returns (bytes memory punkAssets) {
        if (index < cryptoPunksCount) {
            punkAssets = parseAssets(cryptoPunksData.punkAttributes(index));
        } else {
            require(_exists(index));
            punkAssets = new bytes(8);
            for (uint8 j = 0; j < 8; j++) {
                punkAssets[j] = punks[index][j];
            }
        }
    }

    function punkAssetsAttributes(bytes memory punkAssets, uint16 index) internal view returns (string memory text) {
        for (uint8 j = 0; j < 8; j++) {
            uint8 asset = uint8(punkAssets[j]);
            if (asset > 0) {
                if (j > 0) {
                    text = string(abi.encodePacked(text, ", ", getAssetName(asset)));
                } else {
                    text = getAssetName(asset);
                }
            } else {
                break;
            }
        }
        if (index < punksCount) {
            text = string(abi.encodePacked(text, ", Generation: ", Strings.toString(generationMapping[index])));
            text = string(abi.encodePacked(text, ", Father: ", (index < cryptoPunksCount) ? "-" : Strings.toString(fatherMapping[index])));
            text = string(abi.encodePacked(text, ", Mother: ", (index < cryptoPunksCount) ? "-" : Strings.toString(motherMapping[index])));
            uint16 child1 = child1Mapping[index];
            text = string(abi.encodePacked(text, ", Child 1: ", child1 > 0 ? Strings.toString(child1) : "-"));
            uint16 child2 = child2Mapping[index];
            text = string(abi.encodePacked(text, ", Child 2: ", child2 > 0 ? Strings.toString(child2) : "-"));
        }
    }

    function appendAttribute(string memory prefix, string memory key, string memory value, bool asString, bool asNumber, bool append) internal pure returns (string memory text) {
        string memory quote = asString ? '"' : '';
        string memory displayType = asNumber ? '"display_type": "number", ' : '';
        string memory attribute =
            string(abi.encodePacked('{ ', displayType, '"trait_type": "', key, '", "value": ', quote, value, quote, ' }'));
        if (append) {
            text = string(abi.encodePacked(prefix, ', ', attribute));
        } else {
            text = attribute;
        }
    }

    function metadataAttributes(bytes memory punkAssets, uint16 index) internal view returns (string memory text) {
        uint8 accessoryCount = 0;
        for (uint8 j = 0; j < 8; j++) {
            uint8 asset = uint8(punkAssets[j]);
            if (asset > 0) {
                if (j > 0) {
                    ++accessoryCount;
                    text = appendAttribute(text, "Accessory", getAssetName(asset), true, false, true);
                } else {
                    text = appendAttribute(text, "Type", getAssetName(asset), true, false, false);
                }
            } else {
                break;
            }
        }
        text = appendAttribute(text, "# Traits", Strings.toString(accessoryCount), false, false, true);
        text = appendAttribute(text, "Generation", Strings.toString(generationMapping[index]), false, false, true);
        text = appendAttribute(text, "Father", Strings.toString(fatherMapping[index]), false, true, true);
        text = appendAttribute(text, "Mother", Strings.toString(motherMapping[index]), false, true, true);
    }

    function punkAssetsImage(bytes memory punkAssets) internal view returns (bytes memory) {
        bytes memory pixels = new bytes(2304);
        for (uint8 j = 0; j < 8; j++) {
            uint8 asset = uint8(punkAssets[j]);
            if (asset > 0) {
                bytes memory a = getAsset(asset);
                uint n = a.length / 3;
                for (uint i = 0; i < n; i++) {
                    uint[4] memory v = [
                        uint(uint8(a[i * 3]) & 0xF0) >> 4,
                        uint(uint8(a[i * 3]) & 0xF),
                        uint(uint8(a[i * 3 + 2]) & 0xF0) >> 4,
                        uint(uint8(a[i * 3 + 2]) & 0xF)
                    ];
                    for (uint dx = 0; dx < 2; dx++) {
                        for (uint dy = 0; dy < 2; dy++) {
                            uint p = ((2 * v[1] + dy) * 24 + (2 * v[0] + dx)) * 4;
                            if (v[2] & (1 << (dx * 2 + dy)) != 0) {
                                bytes4 c = composite(a[i * 3 + 1], pixels[p], pixels[p + 1], pixels[p + 2], pixels[p + 3]);
                                pixels[p] = c[0];
                                pixels[p+1] = c[1];
                                pixels[p+2] = c[2];
                                pixels[p+3] = c[3];
                            } else if (v[3] & (1 << (dx * 2 + dy)) != 0) {
                                pixels[p] = 0;
                                pixels[p+1] = 0;
                                pixels[p+2] = 0;
                                pixels[p+3] = 0xFF;
                            }
                        }
                    }
                }
            }
        }
        return pixels;
    }

    function colorForGeneration(uint16 index) internal pure returns (bytes4) {
        uint32[9] memory colors = [
            0xFFFFFF00, 0xFAD121FF, 0xA070DDFF,
            0xFA3C6AFF, 0xFD9DCBFF, 0xFC9144FF,
            0x39D27DFF, 0x9CB5FEFF, 0xDEC5A8FF];
        return bytes4(colors[index < colors.length ? index : colors.length - 1]);
    }

    string private constant SVG_HEADER = '<svg id="crisp" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMax meet" viewBox="0 0 360 360">';
    string private constant SVG_FOOTER = '<style>rect{width:15px;height:15px;} #crisp{shape-rendering: crispEdges;} .backdrop{width:360px;height:360px;}</style></svg>';

    function punkAssetsImageSvg(bytes memory punkAssets, uint16 index) internal view returns (string memory svg) {
        bytes memory pixels = punkAssetsImage(punkAssets);
        bytes4 bgColor = colorForGeneration(generationMapping[index]);
        svg = string(abi.encodePacked(SVG_HEADER, rectSvg(0, 0, true, bgColor)));
        for (uint y = 0; y < 24; y++) {
            for (uint x = 0; x < 24; x++) {
                uint p = (y * 24 + x) * 4;
                if (uint8(pixels[p + 3]) > 0) {
                    bytes4 color = bytes4(
                        (uint32(uint8(pixels[p])) << 24) |
                        (uint32(uint8(pixels[p+1])) << 16) |
                        (uint32(uint8(pixels[p+2])) << 8) |
                        (uint32(uint8(pixels[p+3]))));
                    svg = string(abi.encodePacked(svg, rectSvg(15 * x, 15 * y, false, color)));
                }
            }
        }
        svg = string(abi.encodePacked(svg, SVG_FOOTER));
    }

    function punkAttributes(uint16 index) external view returns (string memory text) {
        require(index >= 0 && index < punksCount);
        text = punkAssetsAttributes(getPunkAssets(index), index);
    }

    function punkImageSvg(uint16 index) public view returns (string memory svg) {
        require(index >= 0 && index < punksCount);
        svg = punkAssetsImageSvg(getPunkAssets(index), index);
    }

    function parseAssets(string memory attributes) internal view returns (bytes memory punkAssets) {
        punkAssets = new bytes(8);
        bytes memory stringAsBytes = bytes(attributes);
        bytes memory buffer = new bytes(stringAsBytes.length);

        uint index = 0;
        uint j = 0;
        bool isMale;
        for (uint i = 0; i < stringAsBytes.length; i++) {
            if (i == 0) {
                isMale = (stringAsBytes[i] != "F");
            }
            if (stringAsBytes[i] != ",") {
                buffer[j++] = stringAsBytes[i];
            } else {
                punkAssets[index++] = bytes1(getAssetIndex(bufferToString(buffer, j), isMale));
                i++; // skip space
                j = 0;
            }
        }
        if (j > 0) {
            punkAssets[index++] = bytes1(getAssetIndex(bufferToString(buffer, j), isMale));
        }
    }

    bytes16 private constant HEX_SYMBOLS = "0123456789ABCDEF";

    function rectSvg(uint x, uint y, bool backdrop, bytes4 color) internal pure returns (string memory) {
        bytes memory opaqueBuffer = new bytes(6);
        bytes memory buffer = new bytes(8);
        bool isOpaque = false;
        for (uint i = 0; i < 4; i++) {
            uint8 value = uint8(color[i]);
            buffer[i * 2 + 1] = HEX_SYMBOLS[value & 0xf];
            buffer[i * 2] = HEX_SYMBOLS[(value >> 4) & 0xf];
            if (i < 3) {
                opaqueBuffer[i * 2] = buffer[i * 2];
                opaqueBuffer[i * 2 + 1] = buffer[i * 2 + 1];
            } else if (value == 255) {
                isOpaque = true;
            } else if (value == 0) {
                return '';
            }
        }
        return string(abi.encodePacked(
            '<rect x="', Strings.toString(x), '" y="', Strings.toString(y),
            backdrop ? '" class="backdrop' : '',
            '" fill="#', isOpaque ? string(opaqueBuffer) : string(buffer), '"/>'));
    }

    function bufferToString(bytes memory buffer, uint length) internal pure returns (string memory text) {
        bytes memory stringBuffer = new bytes(length);
        for (uint i = 0; i < length; ++i) {
            stringBuffer[i] = buffer[i];
        }
        text = string(stringBuffer);
    }

    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    // [MIT License]
    // @author Brecht Devos <brecht@loopring.org>
    function base64Encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        uint256 encodedLen = 4 * ((len + 2) / 3);

        bytes memory result = new bytes(encodedLen + 32);
        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}
