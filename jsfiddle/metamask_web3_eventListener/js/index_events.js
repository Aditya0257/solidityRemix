const { json } = require("express");

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
  //* when you first click on 'Listen To Events' button, only a contractInstance
  //* will be created, so you won't be shown any data there.
  //* when you call contractInstance.event.<event name>. and then when there is
  //* data coming in then it'll call the function as mentioned below.
  //* and then this function will write the data as json string.
  
  //todo: to create such an event, to call contractInstance.event.<event name>
  //todo: we are going to send ourselves one token since _to address really doesn't matter
  //todo: in our smart contract. We confirm transaction as we are deploying from 
  //todo: injected metamask and then wait till its complete, then we'll see
  //todo: json string data below the 'Listen to Events' button.

//   contractInstance.events.TokensSent().on("data", (event) => {
//     //? we actually prepend the json string by taking the existing content.
//     eventResult.innerHTML =
//       JSON.stringify(event) + "<br />=====<br />" + eventResult.innerHTML;
//   });

//* What else can we do with it - first of all, right now we can well query 
//* events back to the block zero -> so we can ask a blockchain node to give
//* us all the past events from a smart contract as shown below : -

//todo: contractInstance.getPastEvents("<event name>", {config array}).then((event)=> {});
  contractInstance.getPastEvents("TokensSent", {fromBlock: 0}).then((event)=> {
    eventResult.innerHTML = JSON.stringify(event) + "<br />=====<br />" + eventResult.innerHTML;
  });


  //* LOGGING IN ETHEREUM : -
  //? The EVM currently has 5 opcodes for emitting event logs: LOG0, LOG1, LOG2, LOG3, and LOG4.
  //? These opcodes can be used to create log records. A log record can be used to describe an 
  //? event within a smart contract, like a token transfer or a change of ownership.

  /* Each log record consists of both topics and data. Topics are 32-byte (256 bit) “words” 
  that are used to describe what’s going on in an event. Different opcodes (LOG0 … LOG4) are 
  needed to describe the number of topics that need to be included in the log record. For 
  instance, LOG1 includes one topic, while LOG4 includes four topics. Therefore, the maximum 
  number of topics that can be included in a single log record is four. */

  //! TOPICS IN ETHEREUM LOG RECORDS : - 
  //* 1. first topic in ethereum log records ( log1 ):-
  //? The first topic usually consists of the signature (a keccak256 hash) of the name of the 
  //? event that occurred, including the types (uint256, string, etc.) of its parameters.

  /* One exception where this signature is not included as the first topic is when emitting 
  anonymous events. Since topics can only hold a maximum of 32 bytes of data, things like 
  arrays or strings cannot be used as topics reliably. Instead, it should be included as 
  data in the log record, not as a topic. If you were to try including a topic that’s larger 
  than 32 bytes, the topic will be hashed instead. As a result, this hash can only be reversed 
  if you know the original input. In conclusion, topics should only reliably be used for data 
  that strongly narrows down search queries (like addresses). In conclusion, topics can be 
  seen as indexed keys of the event that all map to the same value. */

  //* 2. We can have up to three more indexed fields, which gives you log2 to log4.
  //  contract ExampleContract {
  //    event Transfer(address indexed _from, address indexed _to, uint256 _value);

  //    function transfer(address _to, uint256 _value){
  //      emit Transfer (msg.sender, _to, _value);
  //    }
  //  }

  //? Since the above contract is not having anonymous event, the first topic will consist
  //? of event signature and then since the first 2 arguments are declared as indexed, they 
  //? are treated like additional topics. Our final argument will not be indexed, which means 
  //? it will be attached as data (instead of a separate topic). This means we are able to 
  //? search for things like “find all Transfer logs from address 0x0000… to address 0x0000…” 
  //? or even “find all logs to address 0x0000…”, but not for things like “find all Transfer 
  //? logs with value x”. We know this event will have 3 topics, which means this logging 
  //? operation will use the LOG3 opcode.

  //todo: If we filter for certain events, we can do that with JavaScript later on very efficiently:
  contractInstance.getPastEvents("TokensSent", {filter : {_to : ['0x123123123...']}, fromBlock: 0})
  .then((event) => {
    console.log(event);

  //? As a rule of thumb, events are about 10-100x cheaper than actually storing something in storage variables.
  });

}
