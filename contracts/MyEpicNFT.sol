// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string svgPartOne = "<svg width='1024px' height='1024px' viewBox='0 0 1024 1024' xmlns='http://www.w3.org/2000/svg'><style>.st1{fill:#fff}.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black'/><text x='1%' y='99%' class='base' dominant-baseline='left' text-anchor='left'>Andy - Binancian</text><g id='Icon'><circle cx='512' cy='512' r='512' style='fill:";
  string svgPartTwo = "'/><path class='st1' d='M404.9 468 512 360.9l107.1 107.2 62.3-62.3L512 236.3 342.6 405.7z'/><path transform='rotate(-45.001 298.629 511.998)' class='st1' d='M254.6 467.9h88.1V556h-88.1z'/><path class='st1' d='M404.9 556 512 663.1l107.1-107.2 62.4 62.3h-.1L512 787.7 342.6 618.3l-.1-.1z'/><path transform='rotate(-45.001 725.364 512.032)' class='st1' d='M681.3 468h88.1v88.1h-88.1z'/><path class='st1' d='M575.2 512 512 448.7l-46.7 46.8-5.4 5.3-11.1 11.1-.1.1.1.1 63.2 63.2 63.2-63.3z'/></g></svg>";

  string[] colors = ["#6b7962", "#6e6680", "#762575", "#f4a261", "#00bac6", "#134351","red", "#08C2A8", "yellow", "blue", "green"];
  string[] firstWords = ["AA", "BB", "CC", "D", "E", "F","G", "H", "I", "J", "K", "L","M","N"];
  string[] secondWords = ["0","1", "2", "3", "4", "5", "6","7","8","9"];
  string[] thirdWords = ["X", "Y", "Z", "OO", "PP","QQ","RR","SS"];
  string[] colors2 = ["red", "#08C2A8", "black", "yellow", "blue", "green"];


  //string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  
  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("Mobowork NFT", "Mobowork") {
    console.log("ERC721 NFT contract constructed");
  }
function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

   
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked("NFT Serial #:",first, second, third));

    
    //string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    //string memory finalSvgData64 = Base64.encode(bytes(finalSvg));


    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo));

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // data:image/svg+xml;base64 
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log(
    string(
        abi.encodePacked(
            "SVG:  ",
            finalSvg
        )
    )
    );
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    
    //Code Generated SVG
    //_setTokenURI(newItemId, finalTokenUri);

    //https://app.pinata.cloud/pinmanager#
    _setTokenURI(newItemId, "ipfs:QmYTyWkD6AsqWnbNZ4N72Cc54gdDcgCwRJWqpatfiUgZmz");
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

 
    emit NewEpicNFTMinted(msg.sender, newItemId);

  }
  

  function generateSVGData() public view returns (string memory) {
    console.log("Generate SVG Data");
    return string(
    abi.encodePacked(
        "data:application/json;base64,",
        "ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LCBQQ0V0TFV4cFkyVnVjMlU2SUUxSlZDNHRMVDRLUEhOMlp5QjNhV1IwYUQwaU1UQXlOSEI0SWlCb1pXbG5hSFE5SWpFd01qUndlQ0lnZG1sbGQwSnZlRDBpTUNBd0lERXdNalFnTVRBeU5DSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNEtJQ0E4YzNSNWJHVStDaUFnSUNBdWMzUXhlMlpwYkd3NkkyWm1abjBLSUNBZ0lDQXVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlFvZ0lEd3ZjM1I1YkdVK0NpQWdQSEpsWTNRZ2QybGtkR2c5SWpFd01DVWlJR2hsYVdkb2REMGlNVEF3SlNJZ1ptbHNiRDBpWW14aFkyc2lMejRLSUNBOGRHVjRkQ0I0UFNJeEpTSWdlVDBpT1RrbElpQmpiR0Z6Y3owaVltRnpaU0lnWkc5dGFXNWhiblF0WW1GelpXeHBibVU5SW14bFpuUWlJSFJsZUhRdFlXNWphRzl5UFNKc1pXWjBJajVCYm1SNUlDMGdRbWx1WVc1amFXRnVQQzkwWlhoMFBnb2dJRHhuSUdsa1BTSkpZMjl1SWo0S0lDQWdJRHhqYVhKamJHVWdZM2c5SWpVeE1pSWdZM2s5SWpVeE1pSWdjajBpTlRFeUlpQnpkSGxzWlQwaVptbHNiRG9qWmpOaVlUSm1JaTgrQ2lBZ0lDQThjR0YwYUNCamJHRnpjejBpYzNReElpQmtQU0pOTkRBMExqa2dORFk0SURVeE1pQXpOakF1T1d3eE1EY3VNU0F4TURjdU1pQTJNaTR6TFRZeUxqTk1OVEV5SURJek5pNHpJRE0wTWk0MklEUXdOUzQzZWlJdlBnb2dJQ0FnUEhCaGRHZ2dkSEpoYm5ObWIzSnRQU0p5YjNSaGRHVW9MVFExTGpBd01TQXlPVGd1TmpJNUlEVXhNUzQ1T1RncElpQmpiR0Z6Y3owaWMzUXhJaUJrUFNKTk1qVTBMallnTkRZM0xqbG9PRGd1TVZZMU5UWm9MVGc0TGpGNklpOCtDaUFnSUNBOGNHRjBhQ0JqYkdGemN6MGljM1F4SWlCa1BTSk5OREEwTGprZ05UVTJJRFV4TWlBMk5qTXVNV3d4TURjdU1TMHhNRGN1TWlBMk1pNDBJRFl5TGpOb0xTNHhURFV4TWlBM09EY3VOeUF6TkRJdU5pQTJNVGd1TTJ3dExqRXRMakY2SWk4K0NpQWdJQ0E4Y0dGMGFDQjBjbUZ1YzJadmNtMDlJbkp2ZEdGMFpTZ3RORFV1TURBeElEY3lOUzR6TmpRZ05URXlMakF6TWlraUlHTnNZWE56UFNKemRERWlJR1E5SWswMk9ERXVNeUEwTmpob09EZ3VNWFk0T0M0eGFDMDRPQzR4ZWlJdlBnb2dJQ0FnUEhCaGRHZ2dZMnhoYzNNOUluTjBNU0lnWkQwaVRUVTNOUzR5SURVeE1pQTFNVElnTkRRNExqZHNMVFEyTGpjZ05EWXVPQzAxTGpRZ05TNHpMVEV4TGpFZ01URXVNUzB1TVM0eExqRXVNU0EyTXk0eUlEWXpMaklnTmpNdU1pMDJNeTR6ZWlJdlBnb2dJRHd2Wno0S1BDOXpkbWMrQ2c9PSIKfQ=="
    )
  );
  }
 
   function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }
  
  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

}

