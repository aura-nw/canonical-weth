#!/bin/bash

RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

if [ "$RPC_URL" = "" ]; then echo -e "${RED_COLOR}- Missing RPC_URL env variable"; return 1; fi
if [ "$WALLET_ADDRESS" = "" ]; then echo -e "${RED_COLOR}- Missing WALLET_ADDRESS env variable"; return 1; fi
if [ "$PRIVATE_KEY" = "" ]; then echo -e "${RED_COLOR}- Missing PRIVATE_KEY env variable"; return 1; fi
if [ "$VERIFIER_URL" = "" ]; then echo -e "${RED_COLOR}- Missing VERIFIER_URL env variable"; return 1; fi

# ====

if [ "$WETH9_ADDR" = "" ]
then
  echo "Deploy WETH9..."
  WETH9_DEPLOY_OUTPUT=$(forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY WETH9 \
    --verify --verifier sourcify --verifier-url $VERIFIER_URL)
  WETH9_ADDR=$(echo ${WETH9_DEPLOY_OUTPUT#*"Deployed to: "} | head -c 42)
  echo -e "${GREEN_COLOR}- deployed to: $WETH9_ADDR"

  if [[ $WETH9_DEPLOY_OUTPUT == *"Contract successfully verified"* ]]; then
    echo -e "${GREEN_COLOR}- verification result: success"
  else
    echo -e "${RED_COLOR}- fail to verify contract $WETH9_ADDR"
    echo "$WETH9_DEPLOY_OUTPUT"
  fi
else
  echo "Skip deploying WETH9. Contract address provided ($WETH9_ADDR)"
fi
