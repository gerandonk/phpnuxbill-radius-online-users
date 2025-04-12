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
                <div class="table-responsive">
                    <table id="onlineTable" class="table table-striped table-bordered table-hover">
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
                                            <input type="hidden" name="username" value="{$userson['username']}">
                                            <input type="hidden" name="nas_ip" value="{$userson['nasipaddress']}">
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
            </div>
        </div>
    </div>
</div>
{if $error != ''}
<div class="panel panel-primary panel-hovered panel-stacked mb30">
    <div class="panel-heading">Results</div>
    <div class="panel-body">
        <div class="bs-callout bs-callout-info" id="callout-navbar-role">
            {foreach $error as $err}
            <h4> {$err}<br></h4>
            {/foreach}
        </div>
    </div>
</div>
{/if}


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script>
    new DataTable('#onlineTable');
</script>

{include file="sections/footer.tpl"}