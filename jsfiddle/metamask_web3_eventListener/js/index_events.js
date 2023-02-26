const enableMetaMaskButton = document.querySelector(".enableMetamask");
const statusText = document.querySelector(".statusText");
const listenToEventsButton = document.querySelector(".startStopEventListener");
const contractAddr = document.querySelector("#address");
const eventResult = document.querySelector(".eventResult");

enableMetaMaskButton.addEventListener("click", () => {
  enableDapp();
});
listenToEventsButton.addEventListener("click", () => {
  listenToEvents();
});

let accounts;
let web3;

//* Steps to run this code : -

//? What we need for web3js to work is the contract ABI and the contract address!

//? In the jsfiddle, We have already provided the ABI array. What we need to do now is to
//? deploy the Smart Contract on a real blockchain (like Goeri), where MetaMask is connected to
//? copy the address from Remix and paste it into the address input field
//? hit "Listen to Events"
//? Head over to Remix and send a token (to any address)
//? Observe the JSFiddle

//todo: here, the smart contract we are deploying is "contracts/26_SampleEvent.sol"
//todo: we have written its abi array and events.TokenSent() line of code of 
//todo: listenToEvents() function also mentions this particular smart contracts event.
//todo: if you want to connect anyother contract, then do the appropirate changes in abi array
//todo: and events line of code below in js.

async function enableDapp() {
    //? MetaMask injects itself into the website. Its reachable with window.ethereum. 
    //? So, if the window.ethereum is not undefined, there's a good reason to 
    //? check whether MetaMask is installed or not.
  if (typeof window.ethereum !== "undefined") {
    try {
    //* Connecting a Website
    //? this method gets the accounts directly if the user already gave connection-consent.
      accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });
    //*  use the window.ethereum as provider for web3js.
      web3 = new Web3(window.ethereum);
      statusText.innerHTML = "Account: " + accounts[0];

      listenToEventsButton.removeAttribute("disabled");
      contractAddr.removeAttribute("disabled");
    } catch (error) {
      if (error.code === 4001) {
        // EIP-1193 userRejectedRequest error
        statusText.innerHTML = "Error: Need permission to access MetaMAsk";
        console.log("Permissions needed to continue.");
      } else {
        console.error(error.message);
      }
    }
  } else {
    statusText.innerHTML = "Error: Need to install MetaMask";
  }
}

let abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "_from",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
    ],
    name: "TokensSent",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
    ],
    name: "sendToken",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "tokenBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];
async function listenToEvents() {
  let contractInstance = new web3.eth.Contract(abi, contractAddr.value);
  contractInstance.events.TokensSent().on("data", (event) => {
    eventResult.innerHTML =
      JSON.stringify(event) + "<br />=====<br />" + eventResult.innerHTML;
  });
}
