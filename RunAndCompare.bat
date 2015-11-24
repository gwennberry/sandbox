@echo off

:: Input:  vcf, bam, outdir
set VCF=%1
set BAM=%2
set OUT=%3
set RerunOld=%4%
set EXPERIMENT=%5

set VCFName=%~n1
set PhasedVcf=%VCFName%.phased.vcf

CP %OUT%\New\%PhasedVcf% %OUT%\New\%PhasedVcf%.%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%.txt
del %OUT%\New\%PhasedVcf%

:: Software Locations
set OldScylla="C:\Users\gberry\Documents\TFS\Illumina.Bioinformatics\Dev\Trunk\tdunn\Clustering\Clustering\bin\x64\Debug\Scylla.exe"
set NewScylla="C:\Users\gberry\Documents\GitHub\IlluminaBioinformatics\Pisces5\src\Scylla\bin\x64\Release\Scylla.exe"
set VcfCompare="\\ussd-prd-isi04\zodiac\Software\Jenkins\AlgorithmConcordance\Tools\VcfCompare\v5.1.2.6\VcfCompare.exe"
set VcfCompare="C:\Users\gberry\Documents\GitHub\IlluminaBioinformatics\Pisces5\src\VcfCompare\bin\x64\Release\VcfCompare.exe"

IF "%RerunOld%"=="true" (
echo ------------------
echo RUN OLD SCYLLA
echo ------------------
%OldScylla% -vcf %VCF% -bam %BAM% -out %OUT%\Old\ -t 1 -debug false
)

echo ------------------
echo RUN NEW SCYLLA
echo ------------------
%NewScylla% -vcf %VCF% -bam %BAM% -out %OUT%\New\ -t 20 -debug false

echo ------------------
echo COMPARE
echo ------------------
%VcfCompare%  %OUT%\Old\%PhasedVcf% %OUT%\New\%PhasedVcf% -AllCheck -AllVars -Refs --Summary=ScyllaCompare_%EXPERIMENT%.csv