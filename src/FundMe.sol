// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts@1.3.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;
    mapping(address => uint256) private s_addressToLifetimeAmountFunded;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Must Be Owner!");
        _;
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Not Enough ETH to Fund!");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_addressToLifetimeAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "No Funds To Withdraw!");
        uint256 fundersLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Failed!");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getAddressToLifetimeAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToLifetimeAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
