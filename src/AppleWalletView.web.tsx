import * as React from 'react';

import { AppleWalletViewProps } from './AppleWallet.types';

export default function AppleWalletView(props: AppleWalletViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
