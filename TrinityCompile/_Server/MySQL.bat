@echo off
COLOR F
echo _____________________Jordythery's Blizzlike Repack______________________
echo _________________________________MySQL 5.5.9____________________________
echo.
echo MySQL is currently running. Please only close this window for shutdown.
echo Please disregard any InoDB messages that are prompted. They have no use.
echo After your server is shut off, press CTRL C to shut down this service.
mysql\bin\mysqld --defaults-file=mysql\bin\my.cnf --standalone --console

if errorlevel 1 goto error
goto finish

:error
echo.
echo MySQL could not be started.
pause

:finish
