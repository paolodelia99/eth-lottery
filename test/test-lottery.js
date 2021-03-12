const { expect } = require("chai");

describe("Lottey", () => {

   let lottery;
   let owner, addr1, addr2, addr3, addrs;
   const tx = { value: 2 };

   let registerAccounts = async () => {
      await lottery.connect(addr1).register(tx);
      await lottery.connect(addr2).register(tx);
      await lottery.connect(addr3).register(tx);
   }

   beforeEach(async function () {
      const Lottery = await ethers.getContractFactory("Lottery");
      lottery = await Lottery.deploy(2, 20);
      [onwer, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();

      await lottery.deployed();
   });

   it("Should initialize the lottery contract", async function () {
      expect(await lottery.maxParticipant()).to.equal(20);
      expect(await lottery.ticketAmount()).to.equal(2);
      expect(await lottery.currentLottery()).to.equal(1);
      expect(await lottery.paused()).to.be.false;
   });

   it("Should register the participants", async function (){

      await registerAccounts();

      expect(await lottery.getCurrentParticipants()).to.equal(3);
      expect(await lottery.getCurrentEtherPrize()).to.equal(6);
   });

   it("Lottery should work properly", async function (){

      await registerAccounts();

      lottery.on("LotteryFinished", (winner, amount) => {
         expect(winner).to.be.oneOf([addr1, addr2, addr3]);
         expect(amount).to.equal(6);
      });

      await lottery.runLottery();
   });
});