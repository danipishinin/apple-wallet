import {
  NativeModulesProxy,
  EventEmitter,
  Subscription,
} from "expo-modules-core";

// Import the native module. On web, it will be resolved to AppleWallet.web.ts
// and on native platforms to AppleWallet.ts
import { ChangeEventPayload, AppleWalletViewProps } from "./AppleWallet.types";
import AppleWalletModule from "./AppleWalletModule";
import AppleWalletView from "./AppleWalletView";

// Get the native constant value.
export const PI = AppleWalletModule.PI;

export function hello(): string {
  return AppleWalletModule.hello();
}

export async function setValueAsync(value: string) {
  return await AppleWalletModule.setValueAsync(value);
}

export async function isDeviceEligibleForAppleWallet(): Promise<boolean> {
  return AppleWalletModule.isDeviceEligibleForAppleWallet();
}

export async function canAddCardOnWallet(): Promise<boolean> {
  return AppleWalletModule.canAddCardOnWallet();
}

const emitter = new EventEmitter(
  AppleWalletModule ?? NativeModulesProxy.AppleWallet,
);

export function addChangeListener(
  listener: (event: ChangeEventPayload) => void,
): Subscription {
  return emitter.addListener<ChangeEventPayload>("onChange", listener);
}

export { AppleWalletView, AppleWalletViewProps, ChangeEventPayload };
