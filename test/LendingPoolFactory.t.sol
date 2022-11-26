// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {LendingPoolFactory} from "src/LendingPoolFactory.sol";
import {LendingPool} from "src/LendingPool.sol";
import {MockPriceOracle} from "./mocks/MockPriceOracle.sol";
import {PriceOracle} from "src/interface/PriceOracle.sol";

import {Authority} from "../src/utils/AuthInitializable.sol";
import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";

/// @title Lending Pool Factory Test Contract
contract LendingPoolFactoryTest is DSTestPlus {
    // Used variables.
    LendingPoolFactory factory;

    function setUp() public {
        LendingPool pool = new LendingPool();
        // Deploy Lending Pool Factory.
        factory = new LendingPoolFactory(
            address(this),
            Authority(address(0)),
            address(pool)
        );
    }

    function testDeployLendingPool() public {
        (address poolAddress, uint256 id) = factory.deployLendingPool(
            "Test Pool"
        );
        LendingPool pool = LendingPool(poolAddress);
        // Assertions.
        assertEq(factory.poolNumber(), 1);
        assertEq(pool.name(), "Test Pool");
        assertEq(pool.owner(), address(this));

        assertEq(address(pool), address(factory.getPoolFromNumber(id)));
        assertGt(address(pool).code.length, 0);
    }

    function testPoolNumberIncrement() public {
        (address poolAddress1, uint256 id1) = factory.deployLendingPool(
            "Test Pool 1"
        );
        (address poolAddress2, uint256 id2) = factory.deployLendingPool(
            "Test Pool 2"
        );

        LendingPool pool1 = LendingPool(poolAddress1);
        LendingPool pool2 = LendingPool(poolAddress2);

        // Assertions.
        assertFalse(id1 == id2);
        assertFalse(pool1 == pool2);
        assertEq(factory.poolNumber(), 2);
    }
}
