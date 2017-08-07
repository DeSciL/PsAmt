# TODO PSAmt
stwehrli@gmail.com

## Know Bugs / Issues
- Connect-Amt: Needs to be able to set the requester id.
- Connect-Amt: Definition of objects needs to be done on load
- Invoke-Hit: Cannot override question. Add-Hit is linked to external question.
- Reference AWS Tools for Windows PowerShell in Readme (http://aws.amazon.com/powershell/)
- Hide Write-AMTError

## Priority 1
- Check parameter default values. At some methods, string="" are set even if probably not needed.
- Check consequences for new implementation of Add-HIT. 
- Review New-TestHit
- Consider moving the type BonusAmount to another file
- Add overload for Add-QualificationType and allow to provide object
- Add examples to Add-HIT, Add-QualificationTypeFull
- Review PageNumber and PageSize for search functions, e.g.  Get-HitsForQualificationType
- New-HIT: long for Expiration? Needs casting?

## Priority 2
- Enable pipeline
- Implement rest of the functionality / missing and throwing functions
  Get-AssignmentsForHit, Get-HitsForQualificationType, Get-QualificationsForQualificationType
  Get-ReviewableHits, Get-ReviewResultsForHIT, New-QuestionForm,
  Search-Hits, Send-TestEventNotification, Set-HitAsReviewing, Set-HitTypeNotification

## Priority 3
- Reproduce typical files like success file, etc. form command line tools
- Split samples into sections
- Add Pester Unit Tests



