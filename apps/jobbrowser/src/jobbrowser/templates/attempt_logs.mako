## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
  from desktop.views import commonheader, commonfooter
  from django.utils.translation import ugettext as _
%>
<%namespace name="comps" file="jobbrowser_components.mako" />

${commonheader(_('Task Attempt: %(attemptId)s - Job Browser') % dict(attemptId=attempt.attemptId), "jobbrowser", user)}
<div class="container-fluid">
    <h1>${_('Task Attempt: %(attemptId)s - Job Browser') % dict(attemptId=attempt.attemptId)}</h1>
    <div class="row-fluid">
        <div class="span2">
            <div class="well sidebar-nav">
                <ul class="nav nav-list">
                    <li class="nav-header">${_('Attempt ID')}</li>
                    <li>${attempt.attemptId_short}</li>
                    <li class="nav-header">${_('Task')}</li>
                    <li><a href="${url('jobbrowser.views.single_task', jobid=joblnk.jobId, taskid=taskid)}" title="${_('View this task')}">${task.taskId_short}</a>
                    </li>
                    <li class="nav-header">${_('Job')}</li>
                    <li><a href="${url('jobbrowser.views.single_job', jobid=joblnk.jobId)}" title="${_('View this job')}">${joblnk.jobId_short}</a></li>
                    <li class="nav-header">${_('Status')}</li>
                    <li>
                        <%
                            status = attempt.state.lower()
                        %>
                        % if status == 'running' or status == 'pending':
                                <span class="label label-warning">${status}</span>
                        % elif status == 'succeeded':
                                <span class="label label-success">${status}</span>
                        % else:
                                <span class="label">${status}</span>
                        % endif
                    </li>
                </ul>
            </div>
        </div>

        <div class="span10">
            <ul class="nav nav-tabs">
                <li><a href="${ url('jobbrowser.views.single_task_attempt', jobid=joblnk.jobId, taskid=task.taskId, attemptid=attempt.attemptId) }#tmetadata">${_('Metadata')}</a></li>
                <li><a href="${ url('jobbrowser.views.single_task_attempt', jobid=joblnk.jobId, taskid=task.taskId, attemptid=attempt.attemptId) }#tcounters">${_('Counters')}</a></li>
                <li class="active"><a href="#logs" data-toggle="tab">${_('Logs')}</a></li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane active" id="logs">
                    <%
                        log_diagnostic = logs[0]
                        log_stdout = logs[1]
                        log_stderr = logs[2]
                        log_syslog = logs[3]
                    %>
                    <%def name="format_log(raw)">
                        ## have to remove any indentation here or it breaks inside the pre tags
                          % for line in raw.split('\n'):
                              ${ line | h,trim }
                        % endfor
                    </%def>
                    <h2>${_('task diagnostic log')}</h2>
                    % if not log_diagnostic:
                            <pre>-- empty --</pre>
                    % else:
                            <pre>${format_log(log_diagnostic)}</pre>
                    % endif
                    <h2>${_('stdout')}</h2>
                    % if not log_stdout:
                            <pre>-- empty --</pre>
                    % else:
                            <pre>${format_log(log_stdout)}</pre>
                    % endif
                    <h2>${_('stderr')}</h2>
                    % if not log_stderr:
                            <pre>-- empty --</pre>
                    % else:
                            <pre>${format_log(log_stderr)}</pre>
                    % endif
                    <h2>${_('syslog')}</h2>
                    % if not log_syslog:
                            <pre>-- empty --</pre>
                    % else:
                            <pre>${format_log(log_syslog)}</pre>
                    % endif
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" charset="utf-8">
    $(document).ready(function(){
        $("#metadataTable").dataTable({
            "bPaginate": false,
            "bLengthChange": false,
            "bInfo": false,
            "bAutoWidth": false,
            "bFilter": false,
            "aoColumns": [
                { "sWidth": "30%" },
                { "sWidth": "70%" }
            ]
        });

        $(".taskCountersTable").dataTable({
            "bPaginate": false,
            "bLengthChange": false,
            "bInfo": false,
            "bFilter": false,
            "bAutoWidth": false,
            "aoColumns": [
                { "sWidth": "30%" },
                { "sWidth": "70%" }
            ]
        });
    });
</script>
${commonfooter(messages)}
