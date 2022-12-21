// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Float", function () {
  it("test initial value", async function () {
    const FloatContract = await ethers.getContractFactory("Float");
    const Float = await FloatContract.deploy();
    await Float.deployed();
    console.log('Float deployed at:'+ Float.address);

    // take some token addresses
    let tokenAddresses = ["0xdAC17F958D2ee523a2206206994597C13D831ec7", "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"];
    
    // this way look packed numbers with mantissa
    let numbers = [0111000000111001, 1100010100111001, 1101000001101000];
              // [dec 12345 hex 7039, dec 1337 hex C539, dec 4200 hex D068]

    // turn these packed binary numbers into hex          
    let hex = [0x7039, 0xC539, 0xD068]

    // these are numbers we are expecting to get
    let resultNumbers = [12345 * 10**1, 1337 * 10**3, 4200 * 10**3];

    // prepare slot 
    let bytes32Slot = ethers.utils.hexZeroPad(ethers.utils.hexConcat(hex), 32);
    console.log(bytes32Slot);
    
    // add slot to contract
    await Float.addNumbers([0], [bytes32Slot]);

    // add token positons to contract
    await Float.addTokens(tokenAddresses, [[0, 26], [0, 28], [0, 30]]);

    let res = []
    for (let i = 0; i < 3; i++) {
      //get decoded value by token address
      await Float.getValueForToken(tokenAddresses[i]);
      res.push(parseInt(await Float.result(), 10));
      }
    for (let i = 0; i < 3; i++) {
      // check that value is same as expected
      expect(resultNumbers[i]).to.equal(res[i]);
      }
  });
});
