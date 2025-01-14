const DocumentVerification = artifacts.require("DocumentVerification");

contract("DocumentVerification", (accounts) => {
  const sampleHash = "sampleDocumentHash";
  const owner = accounts[0];

  it("should add a document successfully", async () => {
    const instance = await DocumentVerification.deployed();

    // Add document
    await instance.addDocument(sampleHash, { from: owner });

    // Verify document
    const result = await instance.verifyDocument(sampleHash);
    assert.equal(result.exists, true, "Document should exist");
    assert.equal(result.owner, owner, "Owner should match");
  });

  it("should not add the same document twice", async () => {
    const instance = await DocumentVerification.deployed();

    // Attempt to add the same document again
    try {
      await instance.addDocument(sampleHash, { from: owner });
      assert.fail("Expected revert not received");
    } catch (error) {
      assert(error.message.includes("Document already exists"), "Expected 'Document already exists' error");
    }
  });

  it("should return false for non-existent documents", async () => {
    const instance = await DocumentVerification.deployed();
    const result = await instance.verifyDocument("nonExistentHash");
    assert.equal(result.exists, false, "Non-existent document should not exist");
  });
});
