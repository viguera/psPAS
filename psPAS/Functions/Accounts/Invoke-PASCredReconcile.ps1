function Invoke-PASCredReconcile {
	<#
	.SYNOPSIS
	Initiates password reconcile by the CPM to a new random password.

	.DESCRIPTION
	Flags a managed account credentials for an automatic CPM password reconcile.
	The "Initiate CPM password management operations" permission is required.

	.PARAMETER AccountID
	The unique ID  of the account.
	This is retrieved by the Get-PASAccount function.

	.PARAMETER sessionToken
	Hashtable containing the session token returned from New-PASSession

	.PARAMETER WebSession
	WebRequestSession object returned from New-PASSession

	.PARAMETER BaseURI
	PVWA Web Address
	Do not include "/PasswordVault/"

	.PARAMETER PVWAAppName
	The name of the CyberArk PVWA Virtual Directory.
	Defaults to PasswordVault

	.EXAMPLE
	$token | Invoke-PASCredReconcile -AccountID 21_3

	Will mark account with ID of "21_3" for password reconcile by CPM

	.EXAMPLE
	$token | Get-PASAccount xAccount | Invoke-PASCredReconcile

	Will mark xAccount for password reconciliation by CPM

	.INPUTS
	SessionToken, AccountID, WebSession & BaseURI can be piped by  property name

	.OUTPUTS
	None

	.NOTES
	Minimum CyberArk version 9.10

	#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[string]$AccountID,

		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$SessionToken,

		[parameter(
			ValueFromPipelinebyPropertyName = $true
		)]
		[Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,

		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[string]$BaseURI,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[string]$PVWAAppName = "PasswordVault"
	)

	BEGIN {}#begin

	PROCESS {

		#Create URL for request
		$URI = "$baseURI/$PVWAAppName/API/Accounts/$AccountID/Reconcile"

		if($PSCmdlet.ShouldProcess($AccountID, "Mark for password reconcile by CPM")) {

			#send request to web service
			Invoke-PASRestMethod -Uri $URI -Method POST -Headers $SessionToken -WebSession $WebSession

		}

	}#process

	END {}#end

}