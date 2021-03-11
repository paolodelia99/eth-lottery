const { expect } = require("chai");

describe("Lottey", () => {
   it("Should initialize the lottery contract", async function () {
      const Lottery = await ethers.getContractFactory("Lottery");
      const lottery = await Lottery.deploy(2, 20);

      await lottery.deployed();
      expect(await lottery.maxParticipant()).to.equal(20);
      expect(await lottery.ticketAmount()).to.equal(2);
      expect(await lottery.currentLottery()).to.equal(1);
      expect(await lottery.paused()).to.be.false;
   });

   it("Should register the participants", async function (){

   });
});