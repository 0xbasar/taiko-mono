// SPDX-License-Identifier: MIT
//  _____     _ _         _         _
// |_   _|_ _(_) |_____  | |   __ _| |__ ___
//   | |/ _` | | / / _ \ | |__/ _` | '_ (_-<
//   |_|\__,_|_|_\_\___/ |____\__,_|_.__/__/

pragma solidity ^0.8.20;

import { ITierProvider, LibTiers } from "./ITierProvider.sol";

/// @title TaikoConfigProvider
contract TaikoConfigProvider is ITierProvider {
    error TIER_NOT_FOUND();

    uint96 private constant UNIT = 10_000e18; // 10000 Taiko token
    uint24 private constant COOLDOWN_BASE = 24 hours;

    function getTier(uint16 tierId)
        public
        pure
        override
        returns (ITierProvider.Tier memory)
    {
        if (tierId == LibTiers.TIER_OPTIMISTIC) {
            return ITierProvider.Tier({
                verifierName: "tier_optimistic",
                validityBond: 20 * UNIT,
                contestBond: 20 * UNIT,
                cooldownWindow: 4 hours + COOLDOWN_BASE,
                provingWindow: 1 hours,
                maxBlocksToVerify: 10
            });
        }

        if (tierId == LibTiers.TIER_SGX) {
            return ITierProvider.Tier({
                verifierName: "tier_sgx",
                validityBond: 10 * UNIT,
                contestBond: 10 * UNIT,
                cooldownWindow: 3 hours + COOLDOWN_BASE,
                provingWindow: 2 hours,
                maxBlocksToVerify: 8
            });
        }

        if (tierId == LibTiers.TIER_SGX_AND_PSE_ZKEVM) {
            return ITierProvider.Tier({
                verifierName: "tier_sgx_and_pse_zkevm",
                validityBond: 2 * UNIT,
                contestBond: 2 * UNIT,
                cooldownWindow: 2 hours + COOLDOWN_BASE,
                provingWindow: 4 hours,
                maxBlocksToVerify: 6
            });
        }

        if (tierId == LibTiers.TIER_GUARDIAN) {
            return ITierProvider.Tier({
                verifierName: "tier_guardian",
                validityBond: 0,
                contestBond: 0, // not contestable
                cooldownWindow: 1 hours + COOLDOWN_BASE,
                provingWindow: 4 hours,
                maxBlocksToVerify: 4
            });
        }

        revert TIER_NOT_FOUND();
    }

    function getTierIds()
        public
        pure
        override
        returns (uint16[] memory tiers)
    {
        tiers = new uint16[](4);
        tiers[0] = LibTiers.TIER_OPTIMISTIC;
        tiers[1] = LibTiers.TIER_SGX;
        tiers[2] = LibTiers.TIER_SGX_AND_PSE_ZKEVM;
        tiers[3] = LibTiers.TIER_GUARDIAN;
    }

    function getMinTier(uint256 rand) public pure override returns (uint16) {
        if (rand % 1000 == 0) return LibTiers.TIER_SGX_AND_PSE_ZKEVM;
        else if (rand % 100 == 0) return LibTiers.TIER_SGX;
        else return LibTiers.TIER_OPTIMISTIC;
    }
}