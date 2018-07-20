import React, { Component } from 'react';
import { Form, Input, Button, Message } from 'semantic-ui-react';
import web3 from '../ethereum/web3';
import Campaign from '../ethereum/campaign';
import { Router } from '../routes';

class ContributeForm extends Component {
    state = {
        value: '',
        errorMessage: '',
        loading: false
    };

    onSubmit = async event => {
        event.preventDefault();
        this.setState({loading: true, errorMessage: '' });
        const campaign = Campaign(this.props.address);
        try {
            const accounts = await web3.eth.getAccounts();
            console.log('accounts are ' + accounts);
            await campaign.methods.contribute().send({
                from: accounts[0],
                value: web3.utils.toWei(this.state.value, 'ether')
            });

            Router.replaceRoute(`/campaigns/${this.props.address}`);
            this.setState({loading: false});
        }
        catch (err) {
            console.log('Received error when attempting to contribute! ' + err);
            this.setState({errorMessage: err.message});
        }
    };

    render() {
        return (
            <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
                <Form.Field>
                    <label>Amount to Contribute</label>
                    <Input
                    value={this.state.value}
                    onChange={event => this.setState({value: event.target.value})}
                    label="ether"
                    labelPosition="right" />
                </Form.Field>

                <Message error header="Error" content={this.state.errorMessage} />
                <Button primary loading={this.state.loading}>
                    Contribute!
                </Button>
            </Form>
        );
    }
}

export default ContributeForm;