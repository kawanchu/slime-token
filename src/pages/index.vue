<template>
  <div v-if="address !== null && netId === 5777">
    <v-form v-model="valid">
      <v-text-field
        v-model="address"
        label="Address"
        disabled
      ></v-text-field>
      <v-text-field
        v-model="balance"
        label="Balance"
        disabled
      ></v-text-field>
      <v-text-field
        v-model="recipient"
        label="Recipient"
        :rules="[v => !!v || 'Recipient is required']"
      ></v-text-field>
      <v-text-field
        v-model="amount"
        label="Amount"
        type="number"
        :rules="[v => v >= 0 && v <= amount || 'Amount is invalid']"
      ></v-text-field>
      <v-btn
        :disabled="!valid"
        @click="send"
      >Send</v-btn>
    </v-form>
    <br />
    <v-form v-if="receipt !== null">
      <v-text-field
        v-for="(value, key) in receipt"
        :value="value"
        :label="key"
        :key="key"
        disabled
      ></v-text-field>
    </v-form>
  </div>
  <div v-else>
    <span>Please install </span>
    <a href="https://metamask.io">Metamask</a>
    <span> and switch local network (8545)</span>
  </div>
</template>

<script>
  import Web3 from 'web3'
  import SlimeToken from '~~/build/contracts/SlimeToken.json'

  export default {
    data () {
      return {
        web3: null,
        netId: null,
        contract: null,
        decimals: null,
        address: null,
        balance: null,
        recipient: null,
        amount: 0,
        valid: false,
        receipt: null
      }
    },
    mounted () {
      if (process.browser && typeof window.web3 !== 'undefined') {
        this.web3 = new Web3(Web3.givenProvider || 'http://localhost:8545')
        this.web3.eth.net.getId().then(netId => this.netId = netId)
        this.web3.eth.getAccounts().then(addresss => {
          this.address = addresss[0]
          this.contract = new this.web3.eth.Contract(SlimeToken.abi, SlimeToken.networks['5777'].address)
          this.contract.methods.balanceOf(this.address).call().then(balance => {
            this.contract.methods.decimals().call().then(decimals => {
              this.decimals = this.web3.utils.toBN(decimals)
              this.balance = this.web3.utils.toBN(balance).div(this.web3.utils.toBN(10).pow(this.decimals))
            })
          })
        })
      }
    },
    methods: {
      send () {
        this.web3.eth.sendTransaction({
          value: '0x0',
          from: this.address,
          to: this.contract._address,
          data: this.contract.methods.transfer(
            this.recipient,
            this.web3.utils.toBN(this.amount).mul(this.web3.utils.toBN(10).pow(this.decimals)).toString()
          ).encodeABI()
        }).then(receipt => {
          this.receipt = receipt
        })
      }
    }
  }
</script>
