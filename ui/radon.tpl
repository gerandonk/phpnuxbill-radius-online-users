{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                Online User : {$totalCount}
            </div>
            <div class="panel-body">
                <div class="md-whiteframe-z1 mb20 text-center" style="padding: 15px">
					<div class="col-md-8">
                        <form id="site-search" method="post" action="{$_url}plugin/radius_users">
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <span class="fa fa-search"></span>
                                </div>
                                <input type="text" name="search" class="form-control"
                                    placeholder="{$_L['Search_by_Username']}..." value="{$search}">
                                <div class="input-group-btn">
                                    <button class="btn btn-success" type="submit">{$_L['Search']}</button>
                                </div>
                            </div>
                        </form>
                    </div>
				</div>&nbsp;&nbsp;
                <div class="table-responsive">
                    <table class="table">
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>{$_L['Username']}</th>
                            <th>IP NAS</th>
                            <th>{$_L['Type']}</th>
							<th>IP Address</th>
							<th>MAC Address</th>
							<th>Uptime</th>
							<th>Download</th>
							<th>Upload</th>
							<th>{$_L['Manage']}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {$no = 1}
                        {foreach $useron as $userson}
                            <tr>
                                <td>{$no++}</td>
                                <td><a href="{$_url}customers/viewu/{$userson['username']}">{$userson['username']}</a></td>
                                <td>{$userson['nasipaddress']}</td>
                                <td>{$userson['calledstationid']}</td>
                                <td>{$userson['framedipaddress']}</td>
                                <td>{$userson['callingstationid']}</td>
								<td>{secondsToTime($userson['acctsessiontime'])}</td>
								<td>{mikrotik_formatBytes($userson['acctinputoctets'])}</td>
								<td>{mikrotik_formatBytes($userson['acctoutputoctets'])}</td>
								<td>
									<div class="btn-group pull-right">
										<form action="{$_url}plugin/radius_users" method="post">
											<input type="hidden" name="kill" value="true">
											<input type="hidden" name="d" value="{$userson['username']}">
											<input type="hidden" name="dd" value="{$userson['nasipaddress']}">
											<button type="submit" class="btn btn-danger btn-xs" title="Disconnect"
											onclick="return confirm('Disconnect User?')"><span
											class="glyphicon glyphicon-alert" aria-hidden="true"></span>&nbsp;Disconnect</button>
										</form>
									</div>
                                </td>
                            </tr>
                        </tbody>
                    {/foreach}
                </table>
                </div>
                &nbsp; {$paginator['contents']}
            </div>
        </div>
    </div>
</div>
{if $output != ''} <div class="panel panel-primary panel-hovered panel-stacked mb30">
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
    </div> {/if}

{include file="sections/footer.tpl"}