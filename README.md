# Kaibex - An ERC20 Modern and Lightweight Swap

## Also called "Why do you still use Uniswap in 2022"

### What is Kaibex?

Kaibex is the implementation of an idea: creating a swap that supersede Uniswap while retaining 
ERC20 compatibility and aggregating factory, lockers and router.

## The vERC20 interface

vERC20 is the interface that guarantees ERC20 compatibility instead of IERC20

## The virtualized interface

This interface allows Kaibex to manage liquidity and factory functions internally 

## Liquidity

Liquidities are stored in a mapping and are defined by a struct accessible with a liquidity id.
There is no ERC20 token defining liquidity, as the whole liquidity is virtualized.

## Swapping

Easy and useful functions are defined in the Kaibex interface that can be used instead of IUniswapRouter02
interface in any contract with a minimum modification

## Security and locking

Liquidity locking is implemented in Kaibex itself through KaibexLocker contract


