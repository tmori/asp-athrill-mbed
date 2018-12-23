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
#  $Id: MultipleChecker.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/test_scenario/TestScenario.rb"
require "ttc/bin/class/TTCCommon.rb"

#=====================================================================
# TTCModule
#=====================================================================
module TTCModule
  #===================================================================
  # ���饹̾: MultipleChecker
  # ����  ��: ���ʥꥪ�֤Υ��顼�����å�
  #===================================================================
  class MultipleChecker
    include CommonModule
    include TTCModule

    #=================================================================
    # ������: ���󥹥ȥ饯��
    #=================================================================
    def initialize()
      @cConf = Config.new()
      # �ƥ���ID��ʣ�����å�
      @hMultipleTestID = Hash.new{|hash, key|
        hash[key] = []
      }
      # ���ԥ��å����������
      @aSpinlockID     = []
      @aExistSpinFiles = []
      # �Ƽ�����ѥ�᡼��
      @hUnifiedAtrs = {
        :hInthdr    => {},
        :hIsr       => {},
        :hIsr2      => {},
        :hException => {}
      }

=begin
      # ������ֹ���������
      @aIntno            = []
      @aExistIntnoTestID = []
=end
    end

    #=================================================================
    # ������: ���顼�����å��ѤΥǡ������Ǽ����
    #=================================================================
    def store(cTS, sFileName)
      check_class(TestScenario, cTS)  # �ƥ��ȥ��ʥꥪ
      check_class(String, sFileName)  # �ե�����̾

      # ���ԥ��å������å�
      if (@cConf.is_fmp?())
        aSpinNames = cTS.get_spinlock_names()
        @aSpinlockID.concat(aSpinNames)
        if (aSpinNames.size() > 0)
          @aExistSpinFiles.push(sFileName)
        end
      end

=begin
      # ������ֹ�����å�
      aIntno = cTS.get_all_intno()
      @aIntno.concat(aIntno)
      if (aIntno.size() > 0)
        @aExistIntnoTestID.push(cTS.sTestID)
      end
=end

      # �ƥ���ID��ʣ�����å���
      @hMultipleTestID[cTS.sTestID].push(sFileName)
      # �Ƽ�����ѥ�᡼��
      @hUnifiedAtrs[:hInthdr][sFileName]    = cTS.get_inthdr_attributes_by_intno()
      @hUnifiedAtrs[:hIsr][sFileName]       = cTS.get_isr_attributes_by_intno()
      @hUnifiedAtrs[:hIsr2][sFileName]      = cTS.get_isr_attributes_by_intno_and_isrpri()
      @hUnifiedAtrs[:hException][sFileName] = cTS.get_exception_attributes_by_excno()

    end

    #=================================================================
    # ������: ���ʥꥪ�֥��顼�����å���¹Ԥ���
    #=================================================================
    def multiple_check()
      aErrors = []

      # Ʊ���ƥ���ID��ʣ����YAML�����Ѥ��Ƥ�����
      @hMultipleTestID.each{|sTestID, aFileNames|
        ### T7_001: �ƥ���ID����ʣ���Ƥ���
        if (aFileNames.size() > 1)
          sErr = sprintf("T7_001: " + ERR_TESTID_MULTIPLE, sTestID)
          aFileNames.each{|sFileName|
            sErr.concat("\n * #{sFileName}")
          }
          aErrors.push(TTCError.new(sErr))
        end
      }

      # ���ƥ��ȥ����������줵�줿°����ɬ�פʥ��֥������ȤΥ����å�
      ### T7_002: Ʊ�������ֹ���Ф������ߥϥ�ɥ�ˤ�����inhno��intpri��class���ۤʤ�
      ### T7_003: Ʊ�������ֹ���Ф������ߥ����ӥ��롼����ˤ�����intpri���ۤʤ�
      ### T7_004: Ʊ�������ֹ���Ф���isrpri��Ʊ��Υ����ӥ��롼����ˤ�����exinf��class���ۤʤ�
      ### T7_006: Ʊ��CPU�㳰�ϥ�ɥ��ֹ���Ф���CPU�㳰�ϥ�ɥ�ˤ�����class���ۤʤ�
      hChech = {
        :hInthdr    => "T7_002: " + ERR_UNIFIED_ATR_INTHDR,
        :hIsr       => "T7_003: " + ERR_UNIFIED_ATR_ISR,
        :hIsr2      => "T7_004: " + ERR_UNIFIED_ATR_ISR,
        :hException => "T7_006: " + ERR_UNIFIED_ATR_EXCEPTION
      }
      hChech.each{|lKey, sErr|
        begin
          multiple_check_unified_attributes(@hUnifiedAtrs[lKey], sErr)
        rescue TTCError
          aErrors.push($!)
        end
      }


      # �������ֹ�ξ��ͤ�����å�
      hCheck = Hash.new{|hash, key|
        hash[key] = Hash.new{|hash2, key2|
          hash2[key2] = []
        }
      }
      [:hInthdr, :hIsr].each{|lKey|
        @hUnifiedAtrs[lKey].each{|sTestID, hData|
          hData.each_key{|hGroupKeyAtrs|
            hCheck[hGroupKeyAtrs[TSR_PRM_INTNO]][lKey].push(sTestID)
          }
        }
      }
      # �����å�
      # (�ϥå��奭����:hInthdr��:hIsr�ȤʤäƤ��뤬��Ȥ�����)
      hCheck.each{|snIntNo, hGroup|
        ### T7_005: Ʊ�������ֹ���Ф��ơ�����ߥϥ�ɥ�ȳ���ߥ����ӥ��롼�����������Ƥ���
        if (hGroup[:hInthdr].size() > 0 && hGroup[:hIsr].size() > 0)
          sErr = sprintf("T7_005: " + ERR_CONFLICT_INTNO, snIntNo) + "\n"
          sErr.concat(" #{TSR_OBJ_INTHDR}\n")
          hGroup[:hInthdr].sort().each{|sFileName|
            sErr.concat(" * #{sFileName}\n")
          }
          sErr.concat(" #{TSR_OBJ_ISR}\n")
          hGroup[:hIsr].sort().each{|sFileName|
            sErr.concat(" * #{sFileName}\n")
          }
          aErrors.push(TTCError.new(sErr))
        end
      }

=begin
      ### T7_007: ������ֹ�λ��ѿ��������ͤ��Ķ���Ƥ���
      @aIntno = @aIntno.uniq().sort()
      if (@aIntno.size() > @cConf.get_intno_num())
        sErr = "T7_007: " + ERR_OVER_INTNO_SUM + "\n"
        @aExistIntnoTestID.each{|sTestID|
          sErr += " * #{sTestID}\n"
        }
        aErrors.push(TTCError.new(sErr))
      end
=end

      ### T7_F001: ���ԥ��å��ο��������ͤ��Ķ���Ƥ���
      if (@cConf.is_fmp?() && @cConf.get_spinlock_num() != 0)
        @aSpinlockID = @aSpinlockID.uniq().sort()
        if (@aSpinlockID.size() > @cConf.get_spinlock_num())
          sErr = "T7_F001: " + ERR_OVER_SPINLOCK_SUM + "\n"
          @aExistSpinFiles.each{|sFileName|
            sErr += " * #{sFileName}\n"
          }
          aErrors.push(TTCError.new(sErr))
        end
      end

      check_error(aErrors)
    end

    #=================================================================
    # ������: �ѥ�᡼�����ƥ��ȥ������֤����줵��Ƥ��뤫�����å�����
    #=================================================================
    def multiple_check_unified_attributes(hUnifiedAtrs, sErr)
      check_class(Hash, hUnifiedAtrs)  # �����å�����ǡ���
      check_class(String, sErr)        # ���顼��å�����

      # �ѥ�᡼�����Ȥ߹�碌���Ȥ˥ƥ���ID��ޤȤ��
      hGroups = Hash.new{|hash, key|
        hash[key] = Hash.new{|hash2, key2|
          hash2[key2] = []
        }
      }
      hUnifiedAtrs.each{|sTestID, hData|
        hData.each{|hGroupKeyAtrs, aAtrs|
          aAtrs.each{|hAtrs|
            hGroups[hGroupKeyAtrs][hAtrs].push(sTestID)
          }
        }
      }

      # �ѥ�᡼�����Ȥ߹�碌���ۤʤ�ƥ��ȥ����������뤫�����å�
      hGroups.each{|hGroupKeyAtrs, hAtrGroups|
        if (hAtrGroups.size() > 1)
          nNum = 1
          # ���롼��
          aTmp = []
          hGroupKeyAtrs.each{|atr, val|
            aTmp.push("#{atr} = #{val}")
          }
          sErr.concat("\ntarget: " + aTmp.join(", ") + "\n")
          # �Ȥ߹�碌���Ȥ˥ƥ���ID��������
          hAtrGroups.each{|hAtrs, aTestID|
            # �ѥ�᡼�����Ȥ߹�碌
            sErr.concat("-" * 30 + "\n")
            sErr.concat("case#{nNum}: ")
            nNum += 1
            aTmp = []
            hAtrs.each{|atr, val|
              unless (val.nil?())
                aTmp.push("#{atr} = #{val}")
              end
            }
            sErr.concat(aTmp.join(", ") + "\n")
            # �ƥ���ID
            aTestID.each{|sTestID|
              sErr.concat(" * #{sTestID}\n")
            }
          }

          raise(TTCError.new(sErr))
        end
      }
    end
  end
end
