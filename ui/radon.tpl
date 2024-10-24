{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
				<div class="btn-group pull-right">
                    <a href="{$_url}plugin/radon_users_cleandb" style="margin: 0px;"
                    onclick="return confirm('{Lang::T('Are you Sure you want to Clean this Database Table?')}')"
                    class="btn btn-danger btn-xs">{Lang::T('Clear Table')}</a>
                </div>Online User : {$totalCount}                
            </div>
            <div class="panel-body">
                <div class="md-whiteframe-z1 mb20 text-center" style="padding: 15px">
                    <div class="col-md-8">
                        <form id="site-search" method="post" action="{$_url}plugin/radon_users">
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <span class="fa fa-search"></span>
                                </div>
                                <input type="text" name="search" class="form-control"
                                    placeholder="{Lang::T('Search by Username')}..." value="{$search}">
                                <div class="input-group-btn">
                                    <button class="btn btn-success" type="submit">{Lang::T('Search')}</button>
                                </div>
                            </div>
                        </form>
                    </div>&nbsp;
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>{Lang::T('Number')}</th>
                                <th>{Lang::T('Username')}</th>
                                <th>{Lang::T('NAS')}</th>
                                <th>{Lang::T('Type')}</th>
                                <th>{Lang::T('IP Address')}</th>
                                <th>{Lang::T('MAC Address')}</th>
                                <th>{Lang::T('Uptime')}</th>
                                <th>{Lang::T('Upload')}</th>
                                <th>{Lang::T('Download')}</th>
                                <th>{Lang::T('Manage')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {$no = 1}
                            {foreach $useron as $userson}
                                <tr>
                                    <td>{$no++}</td>
                                    <td><a href="{$_url}customers/viewu/{$userson['username']}">{$userson['username']}</a>
                                    </td>
                                    <td>{$userson['nasipaddress']}</td>
                                    <td>{$userson['calledstationid']}</td>
                                    <td>{$userson['framedipaddress']}</td>
                                    <td>{$userson['callingstationid']}</td>
                                    <td>{radon_secondsToTime($userson['acctsessiontime'])}</td>
                                    <td>{radon_formatBytes($userson['acctinputoctets'])}</td>
                                    <td>{radon_formatBytes($userson['acctoutputoctets'])}</td>
                                    <td>
                                        <div class="btn-group pull-right">
                                            <form action="{$_url}plugin/radon_users" method="post">
                                                <input type="hidden" name="kill" value="true">
                                                <input type="hidden" name="d" value="{$userson['username']}">
                                                <input type="hidden" name="dd" value="{$userson['nasipaddress']}">
                                                <button type="submit" class="btn btn-danger btn-xs" title="Disconnect"
                                                    onclick="return confirm('Disconnect User?')"><span
                                                        class="glyphicon glyphicon-alert"
                                                        aria-hidden="true"></span>&nbsp;{Lang::T('Disconnect')}</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                &nbsp; {$paginator['contents']}
            </div>
        </div>
    </div>
</div>
{if $output != ''}
<div class="panel panel-primary panel-hovered panel-stacked mb30">
    <div class="panel-heading">Results</div>
        <div class="panel-body">
            <pre>
            {if $returnCode === 0}
                <p>Disconnect User successfully!</p>
                {else}
                <p>Disconnect User failed. Return code: {$returnCode} : {$output} </p>
            {/if}
            </pre>
        </div>
    </div>
</div>
{/if}

{include file="sections/footer.tpl"}