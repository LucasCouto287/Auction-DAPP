url = "http://127.0.0.1:8545";
var contractAddress = "Auction at 0x692a70D2e424a56D2C6C27aA97D1a86395877b3A";

var abi = [
  {
    constant: false,
    inputs: [
      {
        internalType: "string",
        name: "name",
        type: "string"
      }
    ],
    name: "set",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    inputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "constructor"
  },
  {
    constant: true,
    inputs: [],
    name: "hello",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "yourName",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  }
];
var privateKey =  "9afa3b06340f760946c523fbc8388c66394a9d965511b94d4cc6063091a82002";

var submitSet = document.querySelector("form");
var setNameTerm = document.querySelector(".setName");

var helloBtn = document.querySelector(".hello");
var helloResult = document.querySelector(".helloRes");

var provider;
var walletWithProvider;
var contractInstance;
var contractWithSigner;

submitSet.addEventListener("submit", submitSetFn);
helloBtn.addEventListener("click", helloFn);

function submitSetFn(e) {
  e.preventDefault();
  var str = setNameTerm.value;
  contractWithSigner.set(str).then(async tx => {
    await tx.wait();
    console.log("The set function is finished calling...");
  });
}

function helloFn(e) {
  e.preventDefault();
  while (helloResult.firstChild) {
    helloResult.removeChild(helloResult.firstChild);
  }
  contractWithSigner.hello().then(val => {
    var res = document.createElement("p");
    res.textContent = val;
    helloResult.appendChild(res);
  });
}

window.onload = () => {
  provider = new ethers.providers.JsonRpcProvider(url);
  walletWithProvider = new ethers.Wallet(privateKey, provider);
  contractInstance = new ethers.Contract(contractAddress, abi, provider);
  contractWithSigner = contractInstance.connect(walletWithProvider);
};
