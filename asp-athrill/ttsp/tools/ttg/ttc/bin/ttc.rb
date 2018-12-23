#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: ttc.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
if ($0 == __FILE__)
  TOOL_ROOT = File.expand_path(File.dirname(__FILE__) + "/../../")
  $LOAD_PATH.unshift(TOOL_ROOT)
end
require "optparse"
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/test_scenario/TestScenario.rb"
require "ttc/bin/class/TTCCommon.rb"
require "ttc/bin/class/MultipleChecker.rb"

#=====================================================================
# TTCModule
#=====================================================================
module TTCModule
  #===================================================================
  # ���饹̾: TTC
  # ����  ��: TTC�ᥤ�󥯥饹
  #===================================================================
  class TTC
    include CommonModule
    include TTCModule
    attr_reader :hErrors, :hExclude

    #=================================================================
    # ������: ���󥹥ȥ饯��
    #=================================================================
    def initialize()
      @cConf   = Config.new()  # configure
      @hErrors = Hash.new{|hash, key|  # ���顼����
        hash[key] = []
      }
      @hExclude = Hash.new{|hash, key|  # �Хꥨ����������
        hash[key] = {
          :sMessage   => "",
          :aFileNames => []
        }
      }
      @aFileNames     = []
      @nTestCaseCount = 0
    end

    #=================================================================
    # ������: ��������¹Ԥ�TestScenario���󥹥��󥹤�������֤�
    #=================================================================
    def pre_process(aArgs)
      check_class(Array, aArgs)      # �¹Ի�����

      @aFileNames = parse_option(aArgs)  # ���ץ����ѡ���
      @aFileNames = @aFileNames.uniq().sort()

      # configure����
      sConfFile = @cConf.get_configure_file()
      if (sConfFile.nil?())
        sConfFile = DEFAULT_CONFIG_FILE
      end
      @cConf.load_config(sConfFile)
      @cConf.environment_check()

      # �ե����뤬�����뤫�����å�
      pre_file_check()

      # �ץ�ץ��å��󥰼¹�
      aTestScenario = exec_pre_process()

      # ���顼ɽ��
      print_error()

      # ͭ���ʥ��ʥꥪ���ʤ�
      if (aTestScenario.empty?())
        raise(TTCError.new(ERR_NO_AVAILABLE_SCENARIO))
      end

      return aTestScenario  # [Array]TestScenario���󥹥��󥹤�����
    rescue TTCError
      $stderr.puts ERR_HEADER
      $stderr.puts $!.message()
      print_exclude()
      exit(1)
    rescue TTCMultiError
      $stderr.puts(ERR_HEADER)
      $!.aErrors.each_with_index{|ex, index|
        $stderr.puts("  #{index + 1}. #{ex.message}")
      }
      print_exclude()
      exit(1)
    end

    #=================================================================
    # ������: ���ϥƥ��ȥ��ʥꥪ������å�����TestScenario���󥹥���
    #       : ��������֤�
    #=================================================================
    def exec_pre_process()
      nCnt = 0
      nTotal = @aFileNames.size()

      aTestScenario = []
      cMultipleChecker = MultipleChecker.new()
      @aFileNames.each{|sFileName|
        nCnt += 1

        begin
          bExist = false  # ���ʥꥪ��¸�ߤ��뤫
          # �ե����������ɤ߹���
          hYaml = load_yaml_file(sFileName)
          ### T1_001: ����YAML��Hash�ǤϤʤ�
          unless (hYaml.is_a?(Hash))
            sErr = sprintf("T1_001: " + ERR_INVALID_TYPE_TESTCASE, Hash, hYaml.class())
            raise(YamlError.new(sErr))
          end

          # YAML��Υƥ��ȥ��ʥꥪʬ��
          hYaml.each{|sTestID, hScenario|
            if (sTestID == TSR_LBL_VERSION)
              next
            end
            @nTestCaseCount += 1

            # �ץ��쥹�С�
            if (@cConf.is_no_progress_bar_mode?())
              $stderr.puts "[TTC][#{"%5.1f" % (100 * nCnt.to_f / nTotal.to_f)}\% (#{"%4d" % nCnt}/#{"%4d" % nTotal})] #{sTestID}"
            else
              print_progress("TTC", sTestID, nCnt, nTotal)
            end

            # TestScenario���󥹥�������
            bExist  = true
            hBefore = {sTestID => safe_dup(hScenario)}

            begin
              cTS = make_test_scenario(sTestID, hScenario)
              cMultipleChecker.store(cTS, sFileName)

              # �ǥХå�����
              if (@cConf.is_debug_mode?())
                dump(hBefore, TTC_DEBUG_FILE_BEFORE)
                dump(cTS.to_yaml(), TTC_DEBUG_FILE_AFTER)
              end

              aTestScenario.push(cTS)
            rescue TTCMultiExcludeError
              $!.aErrors.each{|cErr|
                @hExclude[cErr.lErrCode][:sMessage] = cErr.message()
                @hExclude[cErr.lErrCode][:aFileNames].push(sFileName + " (" + sTestID + ")")
              }
              next
            end
          }

          ### T1_002: ����YAML��˥ƥ��ȥ��ʥꥪ��1�Ĥ�ʤ�
          if (bExist == false)
            raise(YamlError.new("T1_002: " + ERR_SCENARIO_NOT_EXIST))
          end
        rescue TTCMultiError
          @hErrors[sFileName].concat($!.aErrors)
        rescue TTCError
          @hErrors[sFileName].push($!)
        end
      }

      # �ץ��쥹�С���ɽ���Υꥻ�å�
      unless (@cConf.is_no_progress_bar_mode?())
        finish_progress("TTC", nTotal)
      end

      # ���ʥꥪ�֥����å�
      cMultipleChecker.multiple_check()

      # �ƥ���ID�ǥ�����
      aTestScenario = aTestScenario.sort{|cTS1, cTS2|
        cTS1.sTestID.downcase() <=> cTS2.sTestID.downcase()
      }

      return aTestScenario  # [Array]TestScenario���󥹥��󥹤�����
    end
    private :exec_pre_process

    #=================================================================
    # ������: 1��ʬ��TestScenario���󥹥��󥹤��������֤�
    #=================================================================
    def make_test_scenario(sTestID, hScenario)
      check_class(String, sTestID)          # �ƥ���ID
      check_class(Object, hScenario, true)  # �ƥ��ȥ��ʥꥪ

      # TestScenario���󥹥��󥹺�����basic_check
      cTS = TestScenario.new(sTestID, hScenario)
      cTS.set_nil_attribute()

      # �䴰
      cTS.complement()
      # �ޥ�������å�
      cTS.scenario_check_macro()

      # global�б�
      unless (@cConf.is_timer_local?())
        cTS.convert_global()
        # �ǥХå�����
        if (@cConf.is_debug_mode?())
          dump(cTS.to_yaml(), TTC_DEBUG_FILE_GLOBAL)
        end
      end

      # �ޥ����ִ�
      cTS.convert_macro()

      # �����å�
      cTS.attribute_check()
      cTS.object_check()
      cTS.condition_check()
      cTS.scenario_check()

      # �Хꥨ�����������å�
      cTS.variation_check()

      # �����ꥢ��
      cTS.alias()
      cTS.init_conditions()

      return cTS  # [TestScenario]1��ʬ��TestScenario���󥹥���
    end
    private :make_test_scenario

    #=================================================================
    # ������: ���Ϥ���ե�����Υ����å��򤹤�
    #=================================================================
    def pre_file_check()
      # ���ϥե����뤬�����ʤ�
      if ($0 != __FILE__)
        # �����å�����ե�����
        aFileNames = [TTC_EXCLUSION_FILE, TTJ_PRINT_FILE]
        aExt = [".c", ".h", ".cfg", ".html"]
        aExt.each{|sExt|
          aFileNames.push(@cConf.get_out_file() + sExt)
        }
        # �ºݤ˳����ƤߤƳ�ǧ
        aFileNames.each{|sFileName|
          if (File.exist?(sFileName))
            begin
              File.open(sFileName, "w"){|cIO|
              }
            rescue SystemCallError
              sErr = sprintf(ERR_CANNOT_OPEN_FILE, sFileName)
              raise(TTCError.new(sErr))
            end
          end
        }
      end

      # �ǥХå������ѥե�������
      if (@cConf.is_debug_mode?())
        aFiles = [TTC_DEBUG_FILE_BEFORE, TTC_DEBUG_FILE_AFTER, TTC_DEBUG_FILE_GLOBAL]
        aFiles.each{|sFileName|
          if (File.exist?(sFileName))
            begin
              File.delete(sFileName)
            rescue SystemCallError
              sErr = sprintf(ERR_CANNOT_OPEN_FILE, sFileName)
              raise(TTCError.new(sErr))
            end
          end
        }
      end
    end

    #=================================================================
    # ������: ���ץ�����ѡ��������ץ����ʳ��ΰ������֤�
    #=================================================================
    def parse_option(aArgs)
      check_class(Array, aArgs)  # ���ޥ�ɥ饤�����

      cOpt = OptionParser.new(banner="Usage: ttg.rb [-a | -f] [options]... [yaml files]...")
      # �С�������������
      cOpt.version = $Version

      # �ץ�ե���������
      cOpt.on("-a", "asp mode"){
        @cConf.set(CFG_PROFILE, "asp")
      }
      cOpt.on("-f", "fmp mode"){
        if (@cConf.is_profile_set?())
          puts cOpt.help()
          exit(1)
        end
        @cConf.set(CFG_PROFILE, "fmp")
      }

      # �ᥤ�󥪥ץ����
      cOpt.on("-c CONFFILE", "set configure file"){|val|
        @cConf.set(CFG_FILE, val)
      }
      cOpt.on("-d", "debug mode on"){|val|
        @cConf.set(CFG_DEBUG_MODE, val)
      }
      cOpt.on("-j", "ttj mode on"){|val|
        @cConf.set(CFG_ENABLE_TTJ, val)
      }
      cOpt.on("-p", "no progress bar mode on"){|val|
        @cConf.set(CFG_NO_PROGRESS_BAR, val)
      }
      cOpt.on("-t", "test program flow mode on"){|val|
        @cConf.set(CFG_TEST_FLOW, val)
      }

      # �������åȤΥϡ��ɥ������������ƥ�����˴ؤ�������
      cOpt.on("--#{CFG_PRC_NUM} NUM", "set processor number"){|val|
        @cConf.set(CFG_PRC_NUM, val)
      }
      cOpt.on("--#{CFG_MAIN_PRCID} NUM", "set main task's processor ID"){|val|
        @cConf.set(CFG_MAIN_PRCID, val)
      }
      cOpt.on("--#{CFG_DEFAULT_CLASS} CLASS", "set main task's class name"){|val|
        @cConf.set(CFG_DEFAULT_CLASS, val)
      }
      cOpt.on("--#{CFG_TIMER_ARCH} TYPE", "set timer architecture [#{TSR_PRM_TIMER_LOCAL} | #{TSR_PRM_TIMER_GLOBAL}]"){|val|
        @cConf.set(CFG_TIMER_ARCH, val)
      }
      cOpt.on("--#{CFG_TIME_MANAGE_PRCID} NUM", "set time manage processor ID"){|val|
        @cConf.set(CFG_TIME_MANAGE_PRCID, val)
      }
      cOpt.on("--#{CFG_TIME_MANAGE_CLASS} CLASS", "set time manage class name"){|val|
        @cConf.set(CFG_TIME_MANAGE_CLASS, val)
      }
      cOpt.on("--#{CFG_TIMER_INT_PRI} INTPRI", "set timer interrupt priority"){|val|
        @cConf.set(CFG_TIMER_INT_PRI, val)
      }
      cOpt.on("--#{CFG_SPINLOCK_NUM} NUM", "set spinlock number"){|val|
        @cConf.set(CFG_SPINLOCK_NUM, val)
      }
      cOpt.on("--#{CFG_IRC_ARCH} TYPE",
              "set irc architecture [#{TSR_PRM_IRC_LOCAL} | #{TSR_PRM_IRC_GLOBAL} | #{TSR_PRM_IRC_COMBINATION}]"){|val|
        @cConf.set(CFG_IRC_ARCH, val)
      }
      cOpt.on("--#{CFG_SUPPORT_GET_UTM} BOOL", "support api \"#{API_GET_UTM}\""){|val|
        @cConf.set(CFG_SUPPORT_GET_UTM, val)
      }
      cOpt.on("--#{CFG_SUPPORT_ENA_INT} BOOL", "support api \"#{API_ENA_INT}\""){|val|
        @cConf.set(CFG_SUPPORT_ENA_INT, val)
      }
      cOpt.on("--#{CFG_SUPPORT_DIS_INT} BOOL", "support api \"#{API_DIS_INT}\""){|val|
        @cConf.set(CFG_SUPPORT_DIS_INT, val)
      }
      cOpt.on("--#{CFG_OWN_IPI_RAISE} BOOL", "support own ipi raise"){|val|
        @cConf.set(CFG_OWN_IPI_RAISE, val)
      }
      cOpt.on("--#{CFG_ENA_EXC_LOCK} BOOL", "support cpu exception in cpu lock"){|val|
        @cConf.set(CFG_ENA_EXC_LOCK, val)
      }
      cOpt.on("--#{CFG_ENA_CHGIPM} BOOL", "support chg_ipm in non task"){|val|
        @cConf.set(CFG_ENA_CHGIPM, val)
      }

      # �������åȰ�¸������Ѱդ���ƥ��ȥ饤�֥��
      cOpt.on("--#{CFG_FUNC_TIME} BOOL", "time function is available"){|val|
        @cConf.set(CFG_FUNC_TIME, val)
      }
      cOpt.on("--#{CFG_FUNC_INTERRUPT} BOOL", "interrupt function is available"){|val|
        @cConf.set(CFG_FUNC_INTERRUPT, val)
      }
      cOpt.on("--#{CFG_FUNC_EXCEPTION} BOOL", "exception function is available"){|val|
        @cConf.set(CFG_FUNC_EXCEPTION, val)
      }

      # ɬ�פ˱������ѹ���ǽ�ʥѥ�᡼��
      cOpt.on("--#{CFG_ALL_GAIN_TIME} BOOL", "set all_gain_time parameter"){|val|
        @cConf.set(CFG_ALL_GAIN_TIME, val)
      }
      cOpt.on("--#{CFG_STACK_SHARE} BOOL", "set stack share mode"){|val|
        @cConf.set(CFG_STACK_SHARE, val)
      }
      cOpt.on("--#{CFG_OUT_FILE} FILE", "set output program file name's prefix"){|val|
        @cConf.set(CFG_OUT_FILE, val)
      }
      cOpt.on("--#{CFG_WAIT_SPIN_LOOP} NUM", "set wait spinlock loop"){|val|
        @cConf.set(CFG_WAIT_SPIN_LOOP, val)
      }
      cOpt.on("--#{CFG_EXCEPT_ARG_NAME} NAME", "set exception arg name"){|val|
        @cConf.set(CFG_EXCEPT_ARG_NAME, val)
      }
      cOpt.on("--#{CFG_YAML_LIBRARY} TYPE", "set yaml library [#{CFG_LIB_YAML} | #{CFG_LIB_KWALIFY}]"){|val|
        @cConf.set(CFG_YAML_LIBRARY, val)
      }
      cOpt.on("--#{CFG_ENABLE_GCOV} BOOL", "enable gcov output"){|val|
        @cConf.set(CFG_ENABLE_GCOV, val)
      }
      cOpt.on("--#{CFG_ENABLE_LOG} BOOL", "enable log output"){|val|
        @cConf.set(CFG_ENABLE_LOG, val)
      }

      # ɸ�४�ץ����
      cOpt.on("-v", "--version", "show version information"){
        puts cOpt.ver()
        exit(1)
      }
      cOpt.on("-h", "--help", "show help (this)"){
        puts cOpt.help()
        exit(1)
      }

      # ���ϼ¹�
      begin
        aPath = cOpt.parse(aArgs)
      rescue OptionParser::ParseError
        $stderr.puts ERR_HEADER
        $stderr.puts ERR_OPTION_INVALID
        $stderr.puts ERR_LINE
      end

      # �ץ�ե����롦�ե�������꤬����Ƥ��ʤ����
      if (aPath.nil?() || aPath.empty?() || !@cConf.is_profile_set?())
        puts cOpt.help()
        exit(1)
      end

      return aPath  # [Array]���ץ����ʳ��ΰ���
    end
    private :parse_option

    #=================================================================
    # ������: ���顼����Ϥ���
    #=================================================================
    def print_error()
      unless (@hErrors.empty?())
        nNum = 0
        $stderr.puts(ERR_HEADER)
        @aFileNames.each{|sFileName|
          if (@hErrors.has_key?(sFileName) && !@hErrors[sFileName].empty?())
            nNum = nNum + 1
            $stderr.puts("* #{sFileName}")
            @hErrors[sFileName].each_with_index{|ex, index|
              if (ex.is_a?(YamlError))
                $stderr.puts("  #{index + 1}. [#{ex.path}]")
                $stderr.puts("  => #{ex.message}")
              else
                $stderr.puts("  #{index + 1}. #{ex.message}")
              end
            }
          end
        }
        $stderr.puts(ERR_LINE)
        $stderr.puts(sprintf(ERR_RESULT, nNum))

        exit(1)
      end
    end
    private :print_error

    #=================================================================
    # ������: �������Ƥ���Ϥ���
    #=================================================================
    def print_exclude()
      unless (@hExclude.empty?())
        # ʸ����κ���Ĺ���ޤޤ��ƥ��ȥ�����������
        nMaxLength = 0
        aTestCases = []
        @hExclude.each_value{|hItem|
          nSize = hItem[:sMessage].size()
          if (nSize > nMaxLength)
            nMaxLength = nSize
          end
          aTestCases.concat(hItem[:aFileNames])
        }
        #aTestCases = aTestCases.uniq()
        # ���׾���
        nExclude = aTestCases.size()
        nPercent = (@nTestCaseCount.to_f() - nExclude) / @nTestCaseCount * 100
        nPercent = nPercent.truncate()
        sTotal   = sprintf(ERR_EXCLUDE_RESULT, nExclude, nPercent, @nTestCaseCount - nExclude, @nTestCaseCount)

        # ����
        $stderr.puts ERR_EXCLUDE_HEADER
        @hExclude.each_value{|hItem|
          $stderr.print(sprintf("* %-#{nMaxLength}s", hItem[:sMessage]))
          $stderr.puts("  #{hItem[:aFileNames].size()} test cases")
        }
        $stderr.puts(ERR_LINE)
        $stderr.puts(sTotal)
        # �ե�����˽���
        File.open(TTC_EXCLUSION_FILE, "w"){|cIO|
          cIO.puts(ERR_EXCLUDE_HEADER)
          @hExclude.each_value{|hItem|
            cIO.puts("\n#{hItem[:sMessage]} (#{hItem[:aFileNames].size()} test cases)")
            hItem[:aFileNames].each{|sFileName|
              cIO.puts("* #{sFileName}")
            }
            cIO.puts(ERR_LINE)
          }
          cIO.puts(sTotal)
        }
      end
    end

    #=================================================================
    # ������: �ǥХå���YAML�ե��������������
    #=================================================================
    def dump(hYaml, sFileName)
      check_class(Hash, hYaml)        # ����YAML
      check_class(String, sFileName)  # ������ե�����̾

      cIO = File.open(sFileName, "a")
      cIO.print("---")
      dump_yaml(cIO, hYaml)
      cIO.puts()
      cIO.close()
    end

    #=================================================================
    # ������: YAML���֥������Ȥ򥽡��Ȥ����Ϥ���
    #=================================================================
    def dump_yaml(cIO, data, nNest = 1)
      check_class(IO, cIO)             # ������IO
      check_class(Object, data, true)  # ���ϥǡ���
      check_class(Integer, nNest)      # �ͥ��ȿ�

      sSpace = "  " * nNest
      if (data.is_a?(Hash))
        cIO.puts()
        aKeys = data.keys()
        bAllInt = aKeys.all?(){|key|
          parse_value(key, @cConf.get_macro()).is_a?(Integer)
        }
        hKeys = {}
        if (bAllInt == true)
          aKeys.each{|key|
            nVal = parse_value(key, @cConf.get_macro())
            hKeys[nVal] = key
          }
        else
          aKeys.each{|key|
            hKeys[key.to_s()] = key
          }
        end
        hKeys.sort().each{|atr, val|
          sOriginal = hKeys[atr]
          cIO.print("#{sSpace}#{sOriginal}:")
          dump_yaml(cIO, data[sOriginal], nNest + 1)
        }
      elsif (data.is_a?(Array))
        cIO.puts()
        data.each{|val|
          cIO.print("#{sSpace}-")
          dump_yaml(cIO, val, nNest + 1)
        }
      elsif (data.nil?())
        cIO.puts()
      else
        cIO.puts(" #{data}")
      end
    end
  end
end


#=====================================================================
# main
#=====================================================================
if ($0 == __FILE__)
  module TTCModule
    include CommonModule

    cTTC = TTC.new()
    aTestScenario = cTTC.pre_process(ARGV)
    cTTC.print_exclude()
  end
end
