// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DocumentVerification {
    struct Document {
        string documentHash;
        address owner;
        uint256 timestamp;
    }

    mapping(string => Document) private documents;

    event DocumentAdded(string indexed documentHash, address indexed owner, uint256 timestamp);

    /// @notice Add a new document to the verification system.
    /// @param _documentHash The hash of the document being added.
    function addDocument(string memory _documentHash) public {
        require(bytes(_documentHash).length > 0, "Document hash cannot be empty");
        require(documents[_documentHash].timestamp == 0, "Document already exists");

        documents[_documentHash] = Document(_documentHash, msg.sender, block.timestamp);

        emit DocumentAdded(_documentHash, msg.sender, block.timestamp);
    }

    /// @notice Verify if a document exists in the system.
    /// @param _documentHash The hash of the document to verify.
    /// @return exists Boolean indicating if the document exists.
    /// @return owner Address of the document owner.
    /// @return timestamp Timestamp when the document was added.
    function verifyDocument(string memory _documentHash)
        public
        view
        returns (bool exists, address owner, uint256 timestamp)
    {
        Document memory doc = documents[_documentHash];
        if (doc.timestamp == 0) {
            return (false, address(0), 0);
        }
        return (true, doc.owner, doc.timestamp);
    }
}
