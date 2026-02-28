import React, { useState } from "react";
import { getContract } from "./contract";

function App() {
  const [account, setAccount] = useState("");

  const connectWallet = async () => {
    if (!window.ethereum) {
      alert("Install MetaMask");
      return;
    }

    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });

    setAccount(accounts[0]);
  };

  const addCandidate = async () => {
  try {
    console.log("Getting contract...");
    const contract = await getContract();
    console.log("Contract:", contract);

    console.log("Sending tx...");
    const tx = await contract.addCandidate("Charlie");
    console.log("TX object:", tx);

    await tx.wait();
    alert("Candidate Added!");
  } catch (error) {
    console.error("FULL ERROR:", error);
    alert(error?.reason || error?.message || "Transaction failed");
  }
};

  return (
    <div style={{ padding: "40px" }}>
      <h1>Blockchain Voting System</h1>

      <button onClick={connectWallet}>
        Connect Wallet
      </button>

      <p>Connected: {account}</p>

      <button onClick={addCandidate}>
        Add Candidate (Admin Only)
      </button>
    </div>
  );
}

export default App;